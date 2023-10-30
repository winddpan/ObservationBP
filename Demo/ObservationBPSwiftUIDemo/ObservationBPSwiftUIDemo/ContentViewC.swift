//
//  ContentViewC.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import ObservationBP
import SwiftUI

struct ContentViewC: View {
    private var person = Person(name: "Tom", age: 12)
    @StateObject private var ref = Ref()
    @State private var randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    )

    var body: some View {
        _$ObservingView {
            if #available(iOS 15.0, *) {
                let _ = Self._printChanges()
            }
            VStack {
                Text(person.name)
                Text("\(person.age)")
                Text(person.list.description)

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
}

private struct PersonNameView: View {
    @State private var person: Person
    fileprivate init(person: Person) {
        self.person = person
    }

    var body: some View {
        _$ObservingView {
            if #available(iOS 15.0, *) {
                let _ = Self._printChanges()
            }
            Text(person.name)
        }
    }
}

private struct PersonAgeView: View {
    @State private var person: Person
    fileprivate init(person: Person) {
        self.person = person
    }

    var body: some View {
        if Bool.random() {
            _$ObservingView {
                if #available(iOS 15.0, *) {
                    let _ = Self._printChanges()
                }
                Text("\(person.age)")
                    .background(Color.red)
            }
        } else {
            _$ObservingView {
                if #available(iOS 15.0, *) {
                    let _ = Self._printChanges()
                }
                Text("\(person.age) 999")
                    .background(Color.blue)
            }
        }
    }
}

#Preview {
    ContentViewC()
}
