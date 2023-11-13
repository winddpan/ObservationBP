
![Demo](https://github.com/winddpan/ObservationBP/blob/master/Demo/ObservationBPSwiftUIDemo/Demo.gif?raw=true)

## Sample
```
import ObservationBP
import SwiftUI

struct CompareDemo_ObservationBP: View {
    @Observing var person: Person

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
