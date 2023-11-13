//
//  CompareDemo_ObservationBP.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/13.
//

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
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
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
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        Text("age \(person.age)")
            .foregroundColor(Color(
                red: .random(in: 0 ... 1),
                green: .random(in: 0 ... 1),
                blue: .random(in: 0 ... 1)
            ))
    }
}