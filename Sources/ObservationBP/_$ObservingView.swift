//
//  ObservingView.swift
//  ObservationBP
//
//  Created by Wei Wang on 2023/08/04.
//

import Combine
import Foundation
import SwiftUI
import ObservationBPImpl

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
        let invalidator = self.invalidator
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
