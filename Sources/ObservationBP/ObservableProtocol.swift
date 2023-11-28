import Foundation
import SwiftUI

public protocol Observable: ObservableUnwrap & AnyObject {}

public protocol ObservableUnwrap {
  associatedtype Object: Observable
  var observableObject: Object? { get }
}

public extension Observable {
  var observableObject: Self? {
    self
  }
}

extension State: ObservableUnwrap where Value: ObservableUnwrap {
  public var observableObject: Value.Object? {
    wrappedValue.observableObject
  }
}

extension Optional: ObservableUnwrap where Wrapped: Observable {
  public var observableObject: Wrapped? {
    self
  }
}
