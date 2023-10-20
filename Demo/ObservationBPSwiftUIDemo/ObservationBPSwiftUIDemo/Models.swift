//
//  Models.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/10/20.
//

import Foundation
import ObservationBP
import SwiftUI

@Observable final class Person {
    var name: String
    var age: Int

    deinit {
        print("Person deinit: \(name)")
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

final class Clz {
    var name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("Clz deinit: \(name)")
    }
}


final class OBClz: ObservableObject {
    var name: String

    init(name: String) {
        self.name = name
    }

    deinit {
        print("OBClz deinit: \(name)")
    }
}

class Ref: ObservableObject {
    deinit {
        print("RefA deinit")
    }

    init() {
        print("RefA init")
    }

    let randomColor = Color(
        red: .random(in: 0 ... 1),
        green: .random(in: 0 ... 1),
        blue: .random(in: 0 ... 1)
    )
}
