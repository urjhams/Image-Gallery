//
//  DetailView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI

struct DetailView: View {
  let item: Item
  
  var body: some View {
    AsyncImage(url: item.url) { image in
      image
        .resizable()
        .scaledToFit()
    } placeholder: {
      ProgressView()
    }
  }
}

#Preview {
  if let url = Bundle.main.url(forResource: "bullElk", withExtension: "jpg") {
    DetailView(item: Item(url: url))
  } else {
    Spacer()
  }
}
