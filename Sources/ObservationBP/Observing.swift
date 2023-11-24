//
//  Observing.swift
//
//  Created by wp on 2023/11/2.
//

import Combine
import Foundation
import SwiftUI

@propertyWrapper
public struct Observing<Value: AnyObject & Observable>: DynamicProperty {
  private var container = Container<Value>()
  private let thunk: () -> Value
  @ObservedObject private var emitter = Emitter()
  @State private var uuid = UUID()

  private let identifier: String

  @MainActor
  public var wrappedValue: Value {
    nonmutating set {
      container.value = newValue
      let emitterWrapper = _emitter
      DispatchQueue.main.async {
        emitterWrapper.wrappedValue.objectWillChange.send(())
      }
    }
    get {
      ensureContainerValue()
      return container.value!
    }
  }

  @MainActor
  public var projectedValue: Bindable {
    return Bindable(observing: self)
  }

  public init(wrappedValue: @autoclosure @escaping () -> Value, line: Int = #line, column: Int = #column) {
    thunk = wrappedValue
    identifier = "\(line)_\(column)"

    print("init", identifier)
  }

  public func update() {
    ensureContainerValue()

    let tracker = container.value!.trackerMap.tracker(of: uuid)
    let emitterWrapper = _emitter
    tracker.open(container.value!) { [weak container] in
      container?.dirty = true
      emitterWrapper.wrappedValue.objectWillChange.send(())
      DispatchQueue.main.async {
        container?.dirty = false
      }
    }

    print(identifier, container.value)

//    if container.dirty {
//      DispatchQueue.main.async {
//        container.dirty = false
//      }
//    }
  }

  private func ensureContainerValue() {
    if !container.firstGet {
      container.firstGet = true
    }
    if container.value == nil {
      container.value = thunk()
    }
  }
}

private final class Emitter: ObservableObject {
  let objectWillChange = PassthroughSubject<Void, Never>()
}

extension Observing: Equatable {
  public static func == (lhs: Observing<Value>, rhs: Observing<Value>) -> Bool {
    if lhs.container.dirty || rhs.container.dirty {
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
  var dirty = false
}

private var trackerKey: UInt = 0
private extension Observable where Self: AnyObject {
  var trackerMap: TrackerMap {
    if let cache = objc_getAssociatedObject(self, &trackerKey) as? TrackerMap {
      return cache
    }
    let new = TrackerMap()
    objc_setAssociatedObject(self, &trackerKey, new, .OBJC_ASSOCIATION_RETAIN)
    return new
  }
}

private class TrackerMap {
  private var map = [UUID: Tracker]()

  func tracker(of uuid: UUID) -> Tracker {
    let tracker: Tracker
    if let value = map[uuid] {
      tracker = value
    } else {
      tracker = Tracker()
      map[uuid] = tracker
    }
    return tracker
  }
}
