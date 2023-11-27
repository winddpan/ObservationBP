import Foundation
import SwiftUI

public protocol ObservableUnwrap {
  var observableObject: Observable { get }
}

public protocol Observable: ObservableUnwrap & AnyObject {}

public extension Observable {
  var observableObject: Observable {
    self
  }
}

extension State: ObservableUnwrap where Value: Observable {
  public var observableObject: Observable {
    wrappedValue
  }
}
