//
//  ContentViewB.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import SwiftUI

struct ContentViewB: View {
    @StateObject private var person = Person13(name: "Tom", age: 12)
    @StateObject private var ref = Ref()
    @State private var randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    )

    var body: some View {
        if #available(iOS 15.0, *) {
            Self._printChanges()
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

private struct PersonNameView: View {
    @StateObject private var person: Person13
    fileprivate init(person: Person13) {
        _person = .init(wrappedValue: person)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            Self._printChanges()
        }
        return Text(person.name)
    }
}

private struct PersonAgeView: View {
    @StateObject private var person: Person13
    fileprivate init(person: Person13) {
        _person = .init(wrappedValue: person)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            Self._printChanges()
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
    ContentViewB()
}
