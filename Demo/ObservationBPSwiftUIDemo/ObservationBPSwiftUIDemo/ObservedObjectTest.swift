//
//  ObservedObjectTest.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/2.
//

import ObservationBP
import SwiftUI

struct ObservedObjectTest: View {
    @State var count = 0

    var body: some View {
        VStack {
            Text("刷新 CounterView 计数 :\(count)")
            Button("刷新") {
                count += 1
            }

            CountView1State()
                .padding()

            CountView2State()
                .padding()

            CountView3State()
                .padding()
        }
    }
}

class StateObjectClass: ObservableObject {
    let type: String
    let id: Int
    @Published var count = 0

    init(type: String) {
        self.type = type
        id = Int.random(in: 0 ... 1000)
        print("type:\(type) id:\(id) init")
    }

    deinit {
        print("type:\(type) id:\(id) deinit")
    }
}

@Observable class ObservableClass {
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

struct CountView1State: View {
    @Observing var state = ObservableClass(type: "Observing")

    var body: some View {
        VStack {
            Text("Observing count :\(state.count)")
            Button("+1") {
                state.count += 1
            }
        }
    }
}

struct CountView2State: View {
    @StateObject var state = StateObjectClass(type: "StateObject")

    var body: some View {
        VStack {
            Text("StateObject count :\(state.count)")
            Button("+1") {
                state.count += 1
            }
        }
    }
}

struct CountView3State: View {
    @ObservedObject var state = StateObjectClass(type: "ObservedObject")

    var body: some View {
        VStack {
            Text("ObservedObject count :\(state.count)")
            Button("+1") {
                state.count += 1
            }
        }
    }
}

#Preview {
    ObservedObjectTest()
}
