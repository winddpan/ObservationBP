//
//  CompareDemoView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/13.
//

import ObservationBP
import SwiftUI

@available(iOS 17.0, *)
struct CompareDemoView: View {
    @State var person17 = Person17(name: "name", age: 1)
    @Observing var person = Person(name: "name", age: 1)
    @StateObject var person13 = Person13(name: "name", age: 1)

    var body: some View {
        VStack {
            HStack {
                Button("+") {
                    person.age += 1
                    person13.age += 1
                    person17.age += 1
                }
                .padding()

                Button("-") {
                    person.age -= 1
                    person13.age -= 1
                    person17.age -= 1
                }
                .padding()

                Button("name") {
                    person.name += "@"
                    person13.name += "@"
                    person17.name += "@"
                }
                .padding()
            }
            .padding()

            List {
                Section {
                    Text("iOS17 Observation")
                    CompareDemo_Observation(person: person17)
                }

                Section {
                    Text("ObservationBP")
                    CompareDemo_ObservationBP(person: person)
                }

                Section {
                    Text("StateObject")
                    CompareDemo_StateObject(person: person13)
                }
            }
            .listStyle(.insetGrouped)
            .font(.system(size: 16, weight: .semibold))
        }
    }
}
