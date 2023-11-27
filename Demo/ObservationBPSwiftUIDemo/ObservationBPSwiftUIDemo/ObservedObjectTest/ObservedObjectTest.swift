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

      CountView0State()
        .padding()

      CountView1State()
        .padding()

      CountView2State()
        .padding()

      CountView3State()
        .padding()

      if #available(iOS 17.0, *) {
        CountView4State()
          .padding()
        CountView5State()
          .padding()
      }
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

struct CountView0State: View {
  @Observing @State var state = ObservableClass(type: "@Observing @State")

  var body: some View {
    VStack {
      Text("@Observing @State :\(state.count)")
      Button("+1") {
        state.count += 1
      }
    }
  }
}

struct CountView1State: View {
  @Observing var state = ObservableClass(type: "@Observing")

  var body: some View {
    VStack {
      Text("@Observing :\(state.count)")
      Button("+1") {
        state.count += 1
      }
    }
  }
}

struct CountView2State: View {
  @StateObject var state = StateObjectClass(type: "@StateObject")

  var body: some View {
    VStack {
      Text("@StateObject :\(state.count)")
      Button("+1") {
        state.count += 1
      }
    }
  }
}

struct CountView3State: View {
  @ObservedObject var state = StateObjectClass(type: "@ObservedObject")

  var body: some View {
    VStack {
      Text("@ObservedObject :\(state.count)")
      Button("+1") {
        state.count += 1
      }
    }
  }
}

@available(iOS 17.0, *)
struct CountView4State: View {
  @State var state = Observable17Class(type: "iOS17 @State @Observation")

  var body: some View {
    VStack {
      Text("iOS17 @State @Observation :\(state.count)")
      Button("+1") {
        state.count += 1
      }
    }
  }
}

@available(iOS 17.0, *)
struct CountView5State: View {
  var state = Observable17Class(type: "iOS17 @Observation")

  var body: some View {
    VStack {
      Text("iOS17 @Observation :\(state.count)")
      Button("+1") {
        state.count += 1
      }
    }
  }
}

#Preview {
  ObservedObjectTest()
}
