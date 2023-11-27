import Combine
import Foundation

final class Container<Value: AnyObject> {
  var value: Value
  var firstGet = false
  var dirty = false

  init(value: Value) {
    self.value = value
  }
}

final class Emitter: ObservableObject {
  let objectWillChange = PassthroughSubject<Void, Never>()
}

private var trackerKey: UInt = 0
extension Observable where Self: AnyObject {
  private var trackerMap: TrackerMap {
    if let cache = objc_getAssociatedObject(self, &trackerKey) as? TrackerMap {
      return cache
    }
    let new = TrackerMap()
    objc_setAssociatedObject(self, &trackerKey, new, .OBJC_ASSOCIATION_RETAIN)
    return new
  }

  func tracker(of uuid: UUID) -> Tracker {
    trackerMap.tracker(of: uuid)
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
