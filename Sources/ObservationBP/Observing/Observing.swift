//
//  Observing.swift
//
//  Created by wp on 2023/11/2.
//

import Foundation
import SwiftUI

@propertyWrapper
public struct Observing<Value: AnyObject & Observable>: DynamicProperty {
  private var container: Container<Value>
  @ObservedObject private var emitter = Emitter()
  @State private var uuid = UUID()

  @MainActor
  public var wrappedValue: Value {
    nonmutating set {
      container.value = newValue
      emitter.objectWillChange.send(())
    }
    get {
      if !container.firstGet {
        container.firstGet = true
      }
      return container.value
    }
  }

  @MainActor
  public var projectedValue: Bindable {
    return Bindable(observing: self)
  }

  public init(wrappedValue: Value) {
    container = .init(value: wrappedValue)
  }

  public func update() {
    let tracker = container.value.tracker(of: uuid)
    let emitterWrapper = _emitter
    tracker.open(container.value) { [weak container] in
      container?.dirty = true
      emitterWrapper.wrappedValue.objectWillChange.send(())
      DispatchQueue.main.async {
        container?.dirty = false
      }
    }
  }
}

extension Observing: Equatable {
  public static func == (lhs: Observing<Value>, rhs: Observing<Value>) -> Bool {
    if lhs.container.dirty || rhs.container.dirty {
      return false
    }
    if lhs.container.value === rhs.container.value {
      return true
    }
    return false
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
