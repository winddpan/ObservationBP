
![Demo](https://github.com/winddpan/ObservationBP/blob/master/Demo/ObservationBPSwiftUIDemo/Demo.gif?raw=true)

## Sample
``` Swift
import ObservationBP
import SwiftUI

@Observable final class Person {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

struct ContentView: View {
    @Observing var person: Person = Person(name: "name", age: 1)

    var body: some View {
        VStack {
            PersonNameView(person: person)
            PersonAgeView(person: person)
        }
    }
}

private struct PersonNameView: View {
    @Observing var person: Person

    var body: some View {
        Text(person.name)
            .foregroundColor(Color(
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1)
            ))
    }
}

private struct PersonAgeView: View {
    @Observing var person: Person

    var body: some View {
        Text("age \(person.age)")
            .foregroundColor(Color(
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1)
            ))
    }
}
```

## Based on
 [onevcat/ObservationBP](https://github.com/onevcat/ObservationBP)

## Improvement
 * No more `ObservationView`
   * Delay closure without `ObservationView` either
 * Instance keep, likes `@State` `@StateObject`
 * Memory leak fix
