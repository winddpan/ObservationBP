//
//  ObservedObjectTestModel17.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/13.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable class Observable17Class {
    let type: String
    let id: Int
    var count = 0

    init(type: String) {
        self.type = type
        id = Int.random(in: 0 ... 1000)
        print("type:\(type) id:\(id) init")
    }

    deinit {
        print("type:\(type) id:\(id) deinit")
    }
}
