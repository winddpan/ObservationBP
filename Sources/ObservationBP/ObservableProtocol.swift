import Foundation
import SwiftUI

public protocol Observable: ObservableUnwrap & AnyObject {}

public protocol ObservableUnwrap {
  var observableObject: Observable { get }
}

extension Observable {
  public var observableObject: Observable {
    self
  }
}

extension State: ObservableUnwrap where Value: Observable {
  public var observableObject: Observable {
    wrappedValue
  }
}
