import Combine
import Foundation
import SwiftUI

private class _$ObservationInvalidator: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @MainActor func invalidate() {
        objectWillChange.send()
    }
}

public struct _$ObservingView<Content: View>: View {
    @ObservedObject private var invalidator = _$ObservationInvalidator()

    private let content: () -> Content
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        return withObservationTracking {
            content()
        } onChange: { [weak invalidator] in
            if let invalidator {
                Task {
                    await invalidator.invalidate()
                }
            }
        }
    }
}
