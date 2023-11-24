//
//  ContentViewD.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/19.
//

import SwiftUI

@available(iOS 17.0, *)
struct ContentView_Observation: View {
  private var person = Person17(name: "Tom", age: 12)
  @State private var randomColor = Color(
    red: .random(in: 0 ... 1),
    green: .random(in: 0 ... 1),
    blue: .random(in: 0 ... 1)
  ).opacity(0.5)

  var body: some View {
    let _ = Self._printChanges()
    VStack {
//      Text(person.name)
//      Text("\(person.age)")
//      Text(person.list.description)

//            LazyView {
//                VStack {
//                    Text("(lazy)" + person.name)
//                        .background(Color(
//                            red: .random(in: 0 ... 1),
//                            green: .random(in: 0 ... 1),
//                            blue: .random(in: 0 ... 1)
//                        ))
//
//                    Text("(lazy)" + "\(person.age)")
//                        .background(Color(
//                            red: .random(in: 0 ... 1),
//                            green: .random(in: 0 ... 1),
//                            blue: .random(in: 0 ... 1)
//                        ))
//                }
//            }
//
      VStack {
//        PersonNameView(person: .init(name: person.name, age: 1))
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

@available(iOS 17.0, *)
private struct PersonNameView: View {
  var person: Person17
  @State private var clz = Clz17(name: Date().description)

  var body: some View {
    let _ = Self._printChanges()
    VStack {
      Text(person.name)
      Text(clz.name)
    }
  }
}

@available(iOS 17.0, *)
private struct PersonAgeView: View {
  var person: Person17

  var body: some View {
    let _ = Self._printChanges()
    Text("\(person.age)")
      .background(Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
      ))
  }
}

@available(iOS 17.0, *)
#Preview {
  ContentView_Observation()
}
