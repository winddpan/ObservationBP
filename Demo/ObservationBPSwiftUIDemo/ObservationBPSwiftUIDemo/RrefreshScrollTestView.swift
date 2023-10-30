//
//  RrefreshScrollTestView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/10/30.
//

import ObservationBP
import SwiftUI

@Observable class ListWrapper {
    private(set) var list: [String] = []
    private(set) var title: String
    private(set) var const: String

    init() {
        title = UUID().uuidString
        const = UUID().uuidString
        Task {
            try await refresh()
        }
    }

    func refresh() async throws {
        try await Task.sleep(nanoseconds: 1000000000)
        var list: [Int] = []
        for _ in 0 ..< 10 {
            list.append(Int.random(in: 1 ... 1000))
        }
        self.list = list.map { "\($0)" }
        title = UUID().uuidString
    }
}

struct RrefreshScrollTestView: ObservationView {
    @State private var wrapper = ListWrapper()

    var observationBody: some View {
        ZStack {
            Color.green

            RefreshableScrollView(wrapper.list) {
                LazyVStack {
                    ForEach(wrapper.list, id: \.self) { item in
                        Text(item)
                            .padding(5)
                    }
                }
                .padding(12)
            }
            .refreshable {
                do {
                    try await wrapper.refresh()
                } catch {
                    print(error)
                }
            }

            VStack {
                Text(wrapper.title)
                    .padding()
                    .onTapGesture {
                        Task {
                            do {
                                try await wrapper.refresh()
                            } catch {
                                print(error)
                            }
                        }
                    }
                ConstView(wrapper: wrapper)
            }
            .background(Color.yellow)
        }
        .ignoresSafeArea(edges: [])
    }

    var observationBody2: some View {
        ZStack {
            Color.green

            LazyVStack {
                ForEach(wrapper.list, id: \.self) { item in
                    Text(item)
                        .padding(5)
                }
            }
            .padding(12)

            Text(wrapper.title)
                .padding()
                .background(Color.yellow)
                .onTapGesture {
                    Task {
                        do {
                            try await wrapper.refresh()
                        } catch {
                            print(error)
                        }
                    }
                }
        }
    }
}

private struct ConstView: ObservationView {
    @State var wrapper: ListWrapper

    var observationBody: some View {
        if #available(iOS 15.0, *) {
            let _ = Self._printChanges()
        }
        Text(wrapper.const)
            .foregroundColor(.red)
            .padding()
    }
}

#Preview {
    RrefreshScrollTestView()
}
