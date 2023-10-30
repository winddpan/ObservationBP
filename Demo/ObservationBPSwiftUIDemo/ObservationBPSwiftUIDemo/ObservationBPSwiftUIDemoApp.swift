//
//  ObservationBPSwiftUIDemoApp.swift
//  ObservationBPSwiftUIDemo
//
//  Created by Wei Wang on 2023/08/04.
//

import SwiftUI

@main
struct ObservationBPSwiftUIDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                NavigationLink(destination: Page1()) { Text("Page1") }
            })
        }
    }
}

struct Page1: View {
    var body: some View {
        VStack {
            NavigationLink(destination: RrefreshScrollTestView()) { Text("RrefreshScrollTestView") }
                .padding()
            NavigationLink(destination: DevView()) { Text("DevView") }
                .padding()
            NavigationLink(destination: ContentViewA()) { Text("@Observation") }
                .padding()
            NavigationLink(destination: ContentViewB()) { Text("ObservableObject") }
                .padding()
            NavigationLink(destination: ContentViewC()) { Text("ObservingView") }
                .padding()

            if #available(iOS 17.0, *) {
                NavigationLink(destination: ContentViewD()) { Text("iOS17 @Observation") }
                    .padding()
            }
        }
    }
}
