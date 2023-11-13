//
//  DevView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/20.
//

import ObservationBP
import SwiftUI

struct DevView: View {
    @Observing
    private var person = DevPerson(name: "Tom", age: 12)

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

            TextField("123", text: $person.name)
                .background(Color.yellow)

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
                PersonName2View(person: person)
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
    }
}

private struct PersonNameView: View {
    @Observing
    var person: DevPerson

    init(person: DevPerson) {
        _person = .init(wrappedValue: person)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        Text(person.name)
    }
}

private struct PersonName2View: View {
    @Observing
    var person: DevPerson

    init(person: DevPerson) {
        _person = .init(wrappedValue: person)
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        TextField("name", text: $person.name)
    }
}

private struct PersonAgeView: View {
    @Observing var person: DevPerson
    init(person: DevPerson) {
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
    DevView()
}

typealias DevPerson = Person

/*
 final class DevPerson {
     private var _name: String
     var name: String {
         init(initialValue) initializes(_name) {
             _name = initialValue
         }
         get {
             print("    access: name", _name)
             access(keyPath: \.name)
             return _name
         }
         set {
             withMutation(keyPath: \.name) {
                 _name = newValue
             }
         }
     }

     private var _age: Int
     var age: Int {
         init(initialValue) initializes(_age) {
             _age = initialValue
         }
         get {
             print("    access: age", _age)
             access(keyPath: \.age)
             return _age
         }
         set {
             withMutation(keyPath: \.age) {
                 _age = newValue
             }
         }
     }

     init(name: String, age: Int) {
         self.name = name
         self.age = age
     }

     @ObservationIgnored private let _$observationRegistrar = ObservationBP.ObservationRegistrar()

     nonisolated func access<Member>(
         keyPath: KeyPath<DevPerson, Member>
     ) {
         _$observationRegistrar.access(self, keyPath: keyPath)
     }

     nonisolated func withMutation<Member, T>(
         keyPath: KeyPath<DevPerson, Member>,
         _ mutation: () throws -> T
     ) rethrows -> T {
         try _$observationRegistrar.withMutation(of: self, keyPath: keyPath, mutation)
     }
 }
  */

extension DevPerson: Observable {}
