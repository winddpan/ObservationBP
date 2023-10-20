//
//  DevView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by winddpan on 2023/10/20.
//

import ObservationBP
import SwiftUI

struct DevView: View {
    private var person = Person(name: "Tom", age: 12)
    @StateObject private var ref = Ref()
    @State private var randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    )

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        VStack {
            Text(person.name)
            Text("\(person.age)")

            VStack {
                PersonNameView(person: person)
                PersonAgeView(person: person)
            }
            .padding()

            HStack {
                Button("+") { person.age += 1 }
                Button("-") { person.age -= 1 }
                Button("name") { person.name += "@" }
            }
        }
        .padding()
        .background(randomColor)
        .foregroundColor(ref.randomColor)
    }
}

private extension DevView {
    struct Impl: View {
        private var person = Person(name: "Tom", age: 12)
        @StateObject private var ref = Ref()
        @State private var randomColor = Color(
            red: .random(in: 0 ... 1),
            green: .random(in: 0 ... 1),
            blue: .random(in: 0 ... 1)
        )

        var body: some View {
            _$ObservingView {
                if #available(iOS 15.0, *) {
                    let _ = Self._printChanges()
                }
                VStack {
                    Text(person.name)
                    Text("\(person.age)")

                    VStack {
                        PersonNameView(person: person)
                        PersonAgeView(person: person)
                    }
                    .padding()

                    HStack {
                        Button("+") {
                            person.age += 1
                        }
                        Button("-") {
                            person.age -= 1
                        }
                        Button("name") {
                            person.name += "@"
                        }
                    }
                }
                .padding()
                .background(randomColor)
                .foregroundColor(ref.randomColor)
            }
        }
    }
}

private struct PersonNameView: View {
    @State private var person: Person
    fileprivate init(person: Person) {
        self.person = person
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        Text(person.name)
    }
}

private extension PersonNameView {
    private struct Impl: View {
        @State private var person: Person
        fileprivate init(person: Person) {
            self.person = person
        }

        var body: some View {
            _$ObservingView {
                if #available(iOS 15.0, *) {
                    let _ = Self._printChanges()
                }
                Text(person.name)
            }
        }
    }
}

private struct PersonAgeView: View {
    @State private var person: Person
    fileprivate init(person: Person) {
        self.person = person
    }

    var body: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        if Bool.random() {
            return Text("\(person.age)")
                .background(Color.red)
        } else {
            return Text("\(person.age) 999")
                .background(Color.blue)
        }
    }
}

private extension PersonAgeView {
    private struct Impl: View {
        @State private var person: Person
        fileprivate init(person: Person) {
            self.person = person
            print("init", self)
        }

        var body: some View {
            if Bool.random() {
                _$ObservingView {
                    if #available(iOS 15.0, *) {
                        let _ = Self._printChanges()
                    }
                    Text("\(person.age)")
                        .background(Color.red)
                }
            } else {
                _$ObservingView {
                    if #available(iOS 15.0, *) {
                        let _ = Self._printChanges()
                    }
                    Text("\(person.age) 999")
                        .background(Color.blue)
                }
            }
        }
    }

    @MainActor
//    @ViewBuilder
    private var observationBody: Impl {
        var mutatingSelf = self
        let ptr = withUnsafePointer(to: &mutatingSelf) {
            UnsafeRawPointer($0)
        }
        let ret = ptr.assumingMemoryBound(to: Impl.self)

//        let ptr2 = withUnsafePointer(to: &ret) {
//            UnsafeRawPointer($0)
//        }
//        let ret = ptr.load(as: Impl.self)
//
        print("observationBody", ptr, ret)
//
        return ret.pointee
    }
}

#Preview {
    DevView()
}

extension DevView {
    @ViewBuilder
    @MainActor
    private var observationBody: Impl {
        var mutatingSelf = self
        let ptr = withUnsafePointer(to: &mutatingSelf) {
            UnsafeRawPointer($0)
        }
        ptr.assumingMemoryBound(to: Impl.self).pointee

//        ptr.load(as: Impl.self)
    }

    static func _makeView(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewInputs)
        -> SwiftUI._ViewOutputs {
        Impl._makeView(view: view[\.observationBody], inputs: inputs)
    }

    static func _makeViewList(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewListInputs)
        -> SwiftUI._ViewListOutputs {
        Impl._makeViewList(view: view[\.observationBody], inputs: inputs)
    }

    static func _viewListCount(inputs: SwiftUI._ViewListCountInputs) -> Int? {
        Impl._viewListCount(inputs: inputs)
    }
}

var cache1: Any?
var cache2: Any?
var cache3: Any?

extension PersonNameView {
    @ViewBuilder
    @MainActor
    private var observationBody: Impl {
        var mutatingSelf = self
        let ptr = withUnsafePointer(to: &mutatingSelf) {
            UnsafeRawPointer($0)
        }
        ptr.assumingMemoryBound(to: Impl.self).pointee

//        ptr.load(as: Impl.self)
    }

    static func _makeView(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewInputs)
        -> SwiftUI._ViewOutputs {
        Impl._makeView(view: view[\.observationBody], inputs: inputs)
    }

    static func _makeViewList(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewListInputs)
        -> SwiftUI._ViewListOutputs {
        Impl._makeViewList(view: view[\.observationBody], inputs: inputs)
    }

    static func _viewListCount(inputs: SwiftUI._ViewListCountInputs) -> Int? {
        Impl._viewListCount(inputs: inputs)
    }
}

extension PersonAgeView {
//    @ViewBuilder
//    @MainActor
//    private var observationBody: Impl {
//        var mutatingSelf = self
//        let ptr = withUnsafePointer(to: &mutatingSelf) {
//            UnsafeRawPointer($0)
//        }
//        ptr.load(as: Impl.self)
//    }

    static func _makeView(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewInputs)
        -> SwiftUI._ViewOutputs {
        Impl._makeView(view: view[\.observationBody], inputs: inputs)
    }

    static func _makeViewList(view: SwiftUI._GraphValue<Self>, inputs: SwiftUI._ViewListInputs)
        -> SwiftUI._ViewListOutputs {
        Impl._makeViewList(view: view[\.observationBody], inputs: inputs)
    }

    static func _viewListCount(inputs: SwiftUI._ViewListCountInputs) -> Int? {
        Impl._viewListCount(inputs: inputs)
    }
}
