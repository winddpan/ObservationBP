//
//  ContentView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by Wei Wang on 2023/08/04.
//

import ObservationBP
import SwiftUI

struct ContentViewA: ObservationView {
    private var person = Person(name: "Tom", age: 12)
    @StateObject private var ref = Ref()
    @State private var randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    )

    var observationBody: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        return VStack {
            Text(person.name)
            Text("\(person.age)")

            VStack {
                PersonNameView(person: person)
                PersonAgeView(person: person)
            }
            .padding()

            HStack {
                Button("+") { person.age += 1 }
                Button("-") { person.age -= 1 }
                Button("name") { person.name += "@" }
            }
        }
        .padding()
        .background(randomColor)
        .foregroundColor(ref.randomColor)
    }
}

// @ObservationView
private struct PersonNameView: ObservationView {
    @State private var person: Person
    @State private var clz = Clz(name: UUID().uuidString.components(separatedBy: "-")[0])
    @StateObject private var obClz = OBClz(name: UUID().uuidString.components(separatedBy: "-")[0])

    fileprivate init(person: Person) {
        self.person = person
    }

    var observationBody: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        VStack {
            Text(person.name)
            Text(clz.name)
            Text(obClz.name)
        }
    }
}

private struct PersonAgeView: ObservationView {
    @State private var person: Person
    fileprivate init(person: Person) {
        self.person = person
    }

    var observationBody: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        if Bool.random() {
            return Text("\(person.age)")
                .background(Color.red)
        } else {
            return Text("\(person.age) 999")
                .background(Color.blue)
        }
    }
}

#Preview {
    ContentViewA()
}
