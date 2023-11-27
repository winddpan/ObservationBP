//
//  ContentViewB.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import SwiftUI

struct ContentView_StateObject: View {
    @StateObject private var person = Person13(name: "Tom", age: 12)
    @State private var randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    ).opacity(0.5)

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        VStack {
            Text(person.name)
            Text("\(person.age)")
            Text(person.list.description)

            LazyView {
                VStack {
                    Text("(lazy)" + person.name)
                        .background(Color(
                            red: .random(in: 0 ... 1),
                            green: .random(in: 0 ... 1),
                            blue: .random(in: 0 ... 1)
                        ))

                    Text("(lazy)" + "\(person.age)")
                        .background(Color(
                            red: .random(in: 0 ... 1),
                            green: .random(in: 0 ... 1),
                            blue: .random(in: 0 ... 1)
                        ))
                }
            }

            VStack {
                PersonNameView(person: person)
                PersonAgeView(person: person)
            }
            .padding()

            HStack {
                Button("+") { person.age += 1 }
                Button("-") { person.age -= 1 }
                Button("name") { person.name += "@" }
                Button("list") { person.list = person.list.shuffled() }
            }
        }
        .padding()
        .background(randomColor)
    }
}

private struct PersonNameView: View {
    @StateObject private var person: Person13
    private var clz = Clz(name: Date().description)

    fileprivate init(person: Person13) {
        _person = .init(wrappedValue: person)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        VStack {
            Text(person.name)
            Text(clz.name)
        }
    }
}

private struct PersonAgeView: View {
    @StateObject private var person: Person13
    fileprivate init(person: Person13) {
        _person = .init(wrappedValue: person)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        Text("\(person.age)")
            .background(Color(
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1)
            ))
    }
}

#Preview {
    ContentView_StateObject()
}
