//
//  ItemView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 23.08.24.
//

import SwiftUI
import CachedAsyncImage

struct ItemView: View {
  let size: Double
  let item: Item
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      CachedAsyncImage(url: item.url) { image in
        image
          .resizable()
          .scaledToFill()
      } placeholder: {
        ProgressView()
      }
      .frame(width: size, height: size)
    }
  }
}

#Preview {
  ItemView(
    size: 300, 
    item: Item(url: Bundle.main.url(forResource: "bullElk", withExtension: "jpg")!)
  )
}
