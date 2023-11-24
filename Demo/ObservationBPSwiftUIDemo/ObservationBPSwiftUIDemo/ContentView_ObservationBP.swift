//
//  ContentViewD.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import ObservationBP
import SwiftUI

struct ContentView_ObservationBP: View {
  @Observing private var person = Person(name: "Tom", age: 12)
  @State private var randomColor = Color(
    red: .random(in: 0 ... 1),
    green: .random(in: 0 ... 1),
    blue: .random(in: 0 ... 1)
  ).opacity(0.5)

  init() {
    print("init!")
  }

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    VStack {
//      Text(person.name)
//      Text("\(person.age)")
//      Text(person.list.description)
//
//      LazyView {
//        VStack {
//          Text("(lazy)" + person.name)
//            .background(Color(
//              red: .random(in: 0 ... 1),
//              green: .random(in: 0 ... 1),
//              blue: .random(in: 0 ... 1)
//            ))
//
//          Text("(lazy)" + "\(person.age)")
//            .background(Color(
//              red: .random(in: 0 ... 1),
//              green: .random(in: 0 ... 1),
//              blue: .random(in: 0 ... 1)
//            ))
//        }
//      }

      VStack {
        PersonNameView(person: .init(name: person.name, age: 1))
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
  @Observing var person: Person
  @State private var clz = Clz(name: Date().description)

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    VStack {
      Text("PersonNameView")
      Text(person.name)
      Text("\(person.age)")
      Text(clz.name)
    }
    .font(.system(size: 10))
    .padding()
  }
}

private struct PersonAgeView: View {
  @Observing var person: Person

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
  ContentView_ObservationBP()
}
