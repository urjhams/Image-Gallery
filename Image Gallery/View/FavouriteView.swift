//
//  FavouriteView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI
import SwiftData

struct FavouriteView: View {
  @Environment(\.modelContext) private var modelContext
    
  @Query var favourites: [ImageEntity]
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
          ForEach(favourites) { img in
            if let thumbURL = URL(string: img.thumbnailURL) {
              NavigationLink {
                DetailView(image: img)
              } label: {
                ItemView(size: 100, item: .init(url: thumbURL))
                  .cornerRadius(20)
              }
            }
          }
        }
      }
      .navigationTitle("Favourte")
    }
  }
}
