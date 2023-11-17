//
//  CompareDemo_Observation.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/13.
//

import Observation
import SwiftUI

@available(iOS 17.0, *)
struct CompareDemo_Observation: View {
    @State var person: Person17

    var body: some View {
        let _ = Self._printChanges()
        VStack {
            PersonNameView_Observation(person: person)
            PersonAgeView_Observation(person: person)
        }
    }
}

@available(iOS 17.0, *)
private struct PersonNameView_Observation: View {
    var person: Person17

    var body: some View {
        let _ = Self._printChanges()
        Text(person.name)
            .foregroundColor(Color(
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1)
            ))
    }
}

@available(iOS 17.0, *)
private struct PersonAgeView_Observation: View {
    var person: Person17

    var body: some View {
        let _ = Self._printChanges()
        Text("age \(person.age)")
            .foregroundColor(Color(
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1)
            ))
    }
}
