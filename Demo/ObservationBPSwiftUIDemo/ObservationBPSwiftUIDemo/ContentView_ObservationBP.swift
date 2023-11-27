//
//  ContentViewD.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import ObservationBP
import SwiftUI

struct ContentView_ObservationBP: View {
  @Observing @State private var person = Person(name: "Tom", age: 12)

  init() {
    print("init!")
  }

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    VStack {
      CardView("RootView") {
        Text(person.name)
        Text("\(person.age)")
        Text(person.list.description)
      }

      CardView("LazyView") {
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
      }

      VStack {
        PersonNameView(person: .init(name: person.name, age: 1))
        PersonAgeView(person: person)
        StateView()
      }

      HStack {
        Button("+") { person.age += 1 }
        Button("-") { person.age -= 1 }
        Button("name") { person.name += "@" }
        Button("list") { person.list = person.list.shuffled() }
      }
    }
    .padding()
  }
}

private struct PersonNameView: View {
  @Observing var person: Person
  @State private var clz = Clz(name: Date().description)

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    CardView("PersonNameView") {
      Text(person.name)
      Text("\(person.age)")
      Text(clz.name)
    }
  }
}

private struct PersonAgeView: View {
  @Observing var person: Person

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    CardView("PersonAgeView") {
      Text("\(person.age)")
        .background(Color(
          red: .random(in: 0 ... 1),
          green: .random(in: 0 ... 1),
          blue: .random(in: 0 ... 1)
        ))
    }
  }
}

private struct StateView: View {
  @Observing @State var person: Person = .init(name: Date().description, age: Int(Date().timeIntervalSince1970))
  @State private var clz = Clz(name: Date().description)

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    CardView("StateView") {
      Text("\(person.age)")
        .background(Color(
          red: .random(in: 0 ... 1),
          green: .random(in: 0 ... 1),
          blue: .random(in: 0 ... 1)
        ))
      Text(clz.name)
    }
  }
}

#Preview {
  ContentView_ObservationBP()
}
