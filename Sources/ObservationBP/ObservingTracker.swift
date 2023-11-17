import Foundation
import ObservationBPLock

private weak var previousTracker: Tracker?

private final class TrackerOne {
  private(set) var accessList = ObservationTracking._AccessList()
  let trackingPtr: UnsafeMutablePointer<ObservationTracking._AccessList>
  let previous: UnsafeMutableRawPointer?
  let onChange: () -> Void

  init(previous: UnsafeMutableRawPointer?, onChange: @escaping () -> Void) {
    trackingPtr = withUnsafeMutablePointer(to: &accessList) { $0 }
    self.previous = previous
    self.onChange = onChange
  }
}

final class Tracker {
  private(set) var isOpening = false
  private var trackers: [TrackerOne] = []
  private var gapTracking: ObservationTracking?

  deinit {
    if isOpening {
      isOpening = false
      _ThreadLocal.value = trackers.first?.previous
      if previousTracker === self {
        previousTracker = nil
      }
    }
  }

  @MainActor
  func open<Value: AnyObject & Observable>(_ value: Value, onChange: @escaping () -> Void) {
    guard !isOpening else { return }
    if let previous = previousTracker {
      previous.close()
      previousTracker = nil
    }
    isOpening = true

    let one = TrackerOne(previous: _ThreadLocal.value, onChange: onChange)
    trackers.append(one)
    _ThreadLocal.value = UnsafeMutableRawPointer(one.trackingPtr)
    previousTracker = self
    startGapTracking(value)

    DispatchQueue.main.async { [weak self] in
      self?.close()
    }
  }

  @MainActor
  func close() {
    defer {
      isOpening = false
      if previousTracker === self {
        previousTracker = nil
      }
    }
    guard isOpening, let lastOne = trackers.last else { return }
    gapTracking?.cancel()
    gapTracking = nil

    let accessList = lastOne.accessList
    if let previous = lastOne.previous {
      let scoped = lastOne.trackingPtr.pointee
      if var prevList = previous.assumingMemoryBound(to: ObservationTracking._AccessList?.self).pointee {
        prevList.merge(scoped)
        previous.assumingMemoryBound(to: ObservationTracking._AccessList?.self).pointee = prevList
      } else {
        previous.assumingMemoryBound(to: ObservationTracking._AccessList?.self).pointee = scoped
      }
    }
    _ThreadLocal.value = lastOne.previous

    ObservationTracking._installTracking(accessList) { [weak lastOne, weak self] in
      lastOne?.onChange()
      self?.trackers.removeAll(where: { $0 === lastOne })
    }
  }

  @MainActor
  func startGapTracking<Value: AnyObject & Observable>(_ value: Value) {
    guard let lastOne = trackers.last else {
      return
    }
    let mirror = Mirror(reflecting: value)
    guard let registrar = mirror.descendant("_$observationRegistrar") as? ObservationRegistrar else { return }

    let trackingPtr = lastOne.trackingPtr
    trackingPtr.pointee.entries[registrar.context.id, default: ObservationTracking.Entry(registrar.context)].insert(allRespondedKeyPath)

    gapTracking = ObservationTracking(trackingPtr.pointee)
    ObservationTracking._installTracking(gapTracking!, willSet: { [weak lastOne, weak self] _ in
      lastOne?.onChange()
      self?.gapTracking?.cancel()
      self?.gapTracking = nil
    })

    trackingPtr.pointee.entries[registrar.context.id]?.properties.remove(allRespondedKeyPath)
  }
}
