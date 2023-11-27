import Foundation
import SwiftUI

@propertyWrapper
public struct XObserving<T, Value: Observable & AnyObject>: DynamicProperty {
  private var container: Container<Value>
  private var _value: T
  @ObservedObject private var emitter = Emitter()
  @State private var uuid = UUID()

  @MainActor
  public var wrappedValue: T {
    set {
      if let val = newValue as? Value {
        container.value = val
      } else if let state = newValue as? State<Value> {
        container.value = state.wrappedValue
      }
      _value = newValue
      emitter.objectWillChange.send(())
    }
    get {
      if !container.firstGet {
        container.firstGet = true
      }
      return _value
    }
  }

  @MainActor
  public var projectedValue: Bindable {
    return Bindable(observing: self)
  }

  public init(stateValue: Value) where T == State<Value> {
    _value = State(initialValue: stateValue)
    container = .init(value: stateValue)
  }

  public init(wrappedValue: T) where T == State<Value> {
    _value = wrappedValue
    container = .init(value: wrappedValue.wrappedValue)
  }

  public init(wrappedValue: T) where T == Value {
    _value = wrappedValue
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

extension XObserving: Equatable {
  public static func == (lhs: XObserving<T, Value>, rhs: XObserving<T, Value>) -> Bool {
    if lhs.container.dirty || rhs.container.dirty {
      return false
    }
    if lhs.container.value === rhs.container.value {
      return true
    }
    return false
  }
}

public extension XObserving {
  @dynamicMemberLookup
  struct Bindable {
    private let observing: XObserving<T, Value>

    fileprivate init(observing: XObserving<T, Value>) {
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
