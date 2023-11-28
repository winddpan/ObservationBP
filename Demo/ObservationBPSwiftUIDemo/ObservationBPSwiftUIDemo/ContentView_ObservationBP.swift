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
  @Observing private var person2: Person?
  @Observing @State private var person3: Person?

  init() {
    print("init!")
  }

  var body: some View {
    if #available(iOS 15.0, *) {
      let _ = Self._printChanges()
    }
    VStack {
      CardView("RootView") {
        TextField("name", text: $person.name)
          
        Text(person.name)
        Text("\(person.age)")
        Text(person.list.description)
//        Text(person2?.name ?? "null person2 name!")
        Text(person3?.name ?? "null person3 name!")
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
        Button("person2/3") {
          self.person2 = Person(name: "person2\(Int.random(in: 1 ... 100))", age: Int.random(in: 1 ... 100))
          self.person3 = Person(name: "person3\(Int.random(in: 1 ... 100))", age: Int.random(in: 1 ... 100))
        }
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
