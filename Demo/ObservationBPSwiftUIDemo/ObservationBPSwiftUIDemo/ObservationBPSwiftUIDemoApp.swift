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
                NavigationLink(destination: LazyView { Page1() }) {
                    Text("Page1")
                }
            })
        }
    }
}

struct Page1: View {
    var body: some View {
        VStack {
            NavigationLink(destination: LazyView { RrefreshScrollTestView() }) { Text("RrefreshScrollTestView") }
                .padding()
            NavigationLink(destination: LazyView { DevView() }) { Text("DevView") }
                .padding()

            NavigationLink(destination: LazyView { ObservedObjectTest() }) { Text("ObservedObjectTest") }
                .padding()

            NavigationLink(destination: LazyView { ContentViewB() }) { Text("<iOS17 ObservableObject") }
                .padding()

            if #available(iOS 17.0, *) {
                NavigationLink(destination: LazyView { ContentViewD() }) { Text("iOS17 @Observation") }
                    .padding()
            }
        }
    }
}
