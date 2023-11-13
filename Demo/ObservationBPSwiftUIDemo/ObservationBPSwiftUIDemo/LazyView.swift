//
//  LazyView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/2.
//

import Foundation
import SwiftUI

public struct LazyView<Content: View>: View {
    private let build: () -> Content
    public init(_ build: @escaping () -> Content) {
        self.build = build
    }

    public var body: Content {
        build()
    }
}
