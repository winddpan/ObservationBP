//
//  ObservationView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import Combine
import Foundation
import ObservationBP
import ObservationBPImpl
import SwiftUI

private class ObservationInvalidator: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()

    @MainActor func invalidate() {
        objectWillChange.send()
    }
}

public struct ObservingView<Content: View>: View {
    @ObservedObject private var invalidator = ObservationInvalidator()

    private let content: () -> Content
    public init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        withObservationTracking {
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
