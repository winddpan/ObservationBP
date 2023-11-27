import Foundation
import SwiftUI

public protocol Observable: ObservableUnwrap & AnyObject {}

public protocol ObservableUnwrap {
  var observableObject: Observable? { get }
}

public extension Observable {
  var observableObject: Observable? {
    self
  }
}

extension State: ObservableUnwrap where Value: ObservableUnwrap {
  public var observableObject: Observable? {
    wrappedValue.observableObject
  }
}

extension Optional: ObservableUnwrap where Wrapped: Observable {
  public var observableObject: Observable? {
    self
  }
}
