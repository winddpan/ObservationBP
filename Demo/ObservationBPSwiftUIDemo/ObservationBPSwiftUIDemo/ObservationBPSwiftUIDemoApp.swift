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
        List {
            if #available(iOS 17.0, *) {
                Section {
                    NavigationLink(destination: LazyView { CompareDemoView() }) { Text("CompareDemoView") }
                        .padding()
                }
            }

            Section {
                if #available(iOS 17.0, *) {
                    NavigationLink(destination: LazyView { ContentView_Observation() }) { Text("iOS17 @Observation") }
                        .padding()
                }

                NavigationLink(destination: LazyView { ContentView_ObservationBP() }) { Text("@ObservationBP") }
                    .padding()

                NavigationLink(destination: LazyView { ContentView_StateObject() }) { Text("<iOS17 StateObject") }
                    .padding()
            }

            Section {
                NavigationLink(destination: LazyView { ObservedObjectTest() }) { Text("Object Instance Keep Test") }
                    .padding()
            }

            Section {
                NavigationLink(destination: LazyView { DevView() }) { Text("DevView") }
                    .padding()
            }

            //            NavigationLink(destination: LazyView { RrefreshScrollTestView() }) { Text("RrefreshScrollTestView") }
            //                .padding()
        }
        .listStyle(.insetGrouped)
    }
}
