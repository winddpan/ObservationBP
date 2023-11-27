import Combine
import Foundation
import SwiftUI

@propertyWrapper
public struct Observing<T: ObservableUnwrap>: DynamicProperty {
  private var _value: T
  private let state = ObservingState()
  private let container = Container<T>()
  @ObservedObject private var emitter = Emitter()
  @State private var uuid = UUID()

  @MainActor
  public var wrappedValue: T {
    nonmutating set {
      container.value = newValue
      emitter.objectWillChange.send(())
    }
    get {
      if !state.firstGet {
        state.firstGet = true
      }
      return container.value ?? _value
    }
  }

  @MainActor
  public var projectedValue: Bindable {
    return Bindable(observing: self)
  }

  public init<Value: Observable>(stateValue: Value) where T == State<Value> {
    _value = State(initialValue: stateValue)
  }

  public init<Value: Observable>(wrappedValue: T) where T == State<Value> {
    _value = wrappedValue
  }

  public init<Value: Observable>(wrappedValue: T) where T == State<Value?> {
    _value = wrappedValue
  }

  public init<Value: Observable>(wrappedValue: T) where T == Value? {
    _value = wrappedValue
  }

  public init(wrappedValue: T) where T: Observable {
    _value = wrappedValue
  }

  public func update() {
    if state.dirty {
      DispatchQueue.main.async {
        state.dirty = false
      }
    }

    if let observableObject = _observableObject {
      let tracker = observableObject.tracker(of: uuid)
      let emitterWrapper = _emitter
      tracker.open(observableObject) { [weak state] in
        state?.dirty = true
        DispatchQueue.main.async {
          emitterWrapper.wrappedValue.objectWillChange.send(())
        }
      }
    }
  }

  private var _observableObject: Observable? {
    (container.value ?? _value).observableObject
  }
}

extension Observing: Equatable {
  public static func == (lhs: Observing<T>, rhs: Observing<T>) -> Bool {
    if lhs.state.dirty || rhs.state.dirty {
      return false
    }
    if lhs._observableObject === rhs._observableObject {
      return true
    }
    return false
  }
}

public extension Observing {
  @dynamicMemberLookup
  struct Bindable {
    private let observing: Observing<T>

    fileprivate init(observing: Observing<T>) {
      self.observing = observing
    }

    @MainActor
    public subscript<V>(dynamicMember keyPath: ReferenceWritableKeyPath<T, V>) -> Binding<V> {
      Binding {
        observing.wrappedValue[keyPath: keyPath]
      } set: { newValue in
        observing.wrappedValue[keyPath: keyPath] = newValue
      }
    }
  }
}

private final class Container<Value> {
  var value: Value?
}

private final class ObservingState {
  var firstGet = false
  var dirty = false
}

private final class Emitter: ObservableObject {
  let objectWillChange = PassthroughSubject<Void, Never>()
}
