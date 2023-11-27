//
//  ContentViewD.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import SwiftUI

@available(iOS 17.0, *)
struct ContentView_Observation: View {
  @State private var person = Person17(name: "Tom", age: 12)

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

@available(iOS 17.0, *)
private struct PersonNameView: View {
  var person: Person17
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

@available(iOS 17.0, *)
private struct PersonAgeView: View {
  var person: Person17

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

@available(iOS 17.0, *)
private struct StateView: View {
  @State var person: Person17 = .init(name: Date().description, age: Int(Date().timeIntervalSince1970))
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

@available(iOS 17.0, *)
#Preview {
  ContentView_Observation()
}
