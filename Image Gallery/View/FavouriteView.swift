//
//  FavouriteView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI

struct FavouriteView: View {
  @Environment(\.modelContext) private var modelContext
  
  @State var viewModel: FavouriteViewModel
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
          ForEach(viewModel.favourites) { img in
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
      .navigationTitle("Gallery")
      .task {
        viewModel.loadFavourite(in: modelContext)
      }
    }
  }
}
