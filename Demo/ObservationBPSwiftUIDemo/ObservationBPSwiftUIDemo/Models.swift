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
  var list: [String] = []

  var getName: String {
    name
  }

  deinit {
    print("Person deinit: \(name)")
  }

  init(name: String, age: Int) {
    self.name = name
    self.age = age

    print("Person init: \(name)")

    var list: [Int] = []
    for i in 0 ..< 5 {
      list.append(i)
    }
    self.list = list.map { "\($0)" }
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
