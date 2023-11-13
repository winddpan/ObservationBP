//
//  Observing.swift
//
//  Created by wp on 2023/11/2.
//

import Combine
import Foundation
import ObservationBPLock
import SwiftUI

@propertyWrapper
public struct Observing<Value: AnyObject & Observable>: DynamicProperty {
    // instance keep, likes @StateObject  https://gist.github.com/Amzd/8f0d4d94fcbb6c9548e7cf0c1493eaff
    @State private var container = Container<Value>()
    @ObservedObject private var emitter = Emitter()

    private let thunk: () -> Value

    @MainActor
    public var wrappedValue: Value {
        set {
            container.value = newValue
            let emitterWrapper = _emitter
            DispatchQueue.main.async {
                emitterWrapper.wrappedValue.objectWillChange.send(())
            }
        }
        get {
            if !container.firstGet {
                container.firstGet = true
            }
            if container.value == nil {
                container.value = thunk()
            }
            if !container.tracker.isRunning {
                let emitterWrapper = _emitter
                container.tracker.open { [weak container] in
                    if let container {
                        container.state.dirty = true
                        DispatchQueue.main.async {
                            emitterWrapper.wrappedValue.objectWillChange.send(())
                        }
                    }
                }
            }
            return container.value!
        }
    }

    @MainActor
    public var projectedValue: Bindable {
        return Bindable(observing: self)
    }

    public init(wrappedValue: @autoclosure @escaping () -> Value) {
        thunk = wrappedValue
    }

    public func update() {
        if container.state.dirty {
            DispatchQueue.main.async {
                container.state.dirty = false
            }
        }
    }
}

private final class Emitter: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
}

extension Observing: Equatable {
    public static func == (lhs: Observing<Value>, rhs: Observing<Value>) -> Bool {
        if lhs.container.state.dirty || rhs.container.state.dirty {
            return false
        }
        if !lhs.container.firstGet || !rhs.container.firstGet {
            return true
        }
        return lhs.container.value === rhs.container.value
    }
}

public extension Observing {
    @dynamicMemberLookup
    struct Bindable {
        private let observing: Observing<Value>

        fileprivate init(observing: Observing<Value>) {
            self.observing = observing
        }

        @MainActor
        public subscript<V>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, V>) -> Binding<V> {
            Binding {
                observing.wrappedValue[keyPath: keyPath]
            } set: { newValue in
                observing.wrappedValue[keyPath: keyPath] = newValue
            }
        }
    }
}

private final class Container<Value: AnyObject> {
    var value: Value?
    var firstGet = false
    private(set) var tracker = Tracker()
    private(set) var state = ObservingState()
}

private final class ObservingState {
    var dirty = false
}

private weak var previousTracker: Tracker?

private final class TrackerOne {
    private(set) var accessList: ObservationTracking._AccessList?
    var ptr: UnsafeMutablePointer<ObservationTracking._AccessList?>?
    var previous: UnsafeMutableRawPointer?
    var onChange: (() -> Void)?

    init() {
        ptr = withUnsafeMutablePointer(to: &accessList) { $0 }
    }
}

private final class Tracker {
    private(set) var isRunning = false
    private var trackers: [TrackerOne] = []

    deinit {
        if isRunning {
            isRunning = false
            _ThreadLocal.value = trackers.first?.previous
            if previousTracker === self {
                previousTracker = nil
            }
        }
    }

    @MainActor
    func open(onChange: @escaping () -> Void) {
        guard !isRunning else { return }
        if let previous = previousTracker {
            previous.close()
            previousTracker = nil
        }
        isRunning = true

        let one = TrackerOne()
        one.onChange = onChange
        one.previous = _ThreadLocal.value
        trackers.append(one)
        _ThreadLocal.value = UnsafeMutableRawPointer(one.ptr)

        previousTracker = self

        DispatchQueue.main.async { [weak self] in
            self?.close()
        }
    }

    @MainActor
    func close() {
        defer {
            isRunning = false
            if previousTracker === self {
                previousTracker = nil
            }
        }
        guard isRunning, let lastOne = trackers.last else { return }

        let accessList = lastOne.accessList
        let ptr = lastOne.ptr

        if let scoped = ptr?.pointee, let previous = lastOne.previous {
            if var prevList = previous.assumingMemoryBound(to: ObservationTracking._AccessList?.self).pointee {
                prevList.merge(scoped)
                previous.assumingMemoryBound(to: ObservationTracking._AccessList?.self).pointee = prevList
            } else {
                previous.assumingMemoryBound(to: ObservationTracking._AccessList?.self).pointee = scoped
            }
        }
        _ThreadLocal.value = lastOne.previous

        if let accessList, lastOne.onChange != nil {
            ObservationTracking._installTracking(accessList) { [weak lastOne, weak self] in
                lastOne?.onChange?()
                self?.trackers.removeAll(where: { $0 === lastOne })
            }
        }
    }
}
