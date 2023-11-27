//
//  CardView.swift
//  ObservationBPSwiftUIDemo
//
//  Created by wp on 2023/11/27.
//

import SwiftUI

struct CardView<Content: View>: View {
  let title: String
  let content: Content

  init(_ title: String, @ViewBuilder content: () -> Content) {
    self.title = title
    self.content = content()
  }

  var body: some View {
    VStack {
      Text(title)
        .font(.system(size: 12))
        .foregroundColor(.white)
        .padding(2)
        .frame(maxWidth: .infinity)
        .background(Color.gray)

      content

      Spacer()
        .frame(height: 5)
    }
    .overlay(
      RoundedRectangle(cornerRadius: 2)
        .stroke(Color.gray, lineWidth: 1)
    )
    .padding()
  }
}
