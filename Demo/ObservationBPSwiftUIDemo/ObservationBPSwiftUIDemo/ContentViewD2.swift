//
//  ContentViewD.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import ObservationBP
import SwiftUI

struct ContentViewD2: View {
    @Observing private var person = Person(name: "Tom", age: 12)
    @StateObject private var ref = Ref()
    @State private var randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    )

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
                        .background(Color.yellow)

                    Text("(lazy)" + "\(person.age)")
                        .background(Color.yellow)
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
        .foregroundColor(ref.randomColor)
    }
}

private struct PersonNameView: View {
    @Observing private var person: Person
    private var clz = Clz(name: UUID().uuidString.components(separatedBy: "-")[0])

    fileprivate init(person: Person) {
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
    @Observing private var person: Person
    fileprivate init(person: Person) {
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
    ContentViewD2()
}
