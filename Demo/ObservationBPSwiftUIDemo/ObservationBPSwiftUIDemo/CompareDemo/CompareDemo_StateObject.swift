//
//  CompareDemo_StateObject.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/13.
//

import SwiftUI

struct CompareDemo_StateObject: View {
    @StateObject var person: Person13

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        VStack {
            PersonNameView_StateObject(person: person)
            PersonAgeView_StateObject(person: person)
        }
    }
}

private struct PersonNameView_StateObject: View {
    @StateObject var person: Person13

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

private struct PersonAgeView_StateObject: View {
    @StateObject var person: Person13

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
