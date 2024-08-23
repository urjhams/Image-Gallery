//
//  GalleryView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI

struct GalleryView: View {
  @Environment(\.modelContext) private var modelContext
  
  @State var viewModel: GalleryViewModel
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
          ForEach(viewModel.images) { img in
            if let thumbURL = URL(string: img.thumbnailUrl), let url = URL(string: img.url) {
              NavigationLink {
                DetailView(item: .init(url: url))
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
        try? await viewModel.loadImages()
      }
    }
  }
}

#Preview {
  GalleryView(viewModel: GalleryViewModel(
    repository: ImageRepository(
      downloader: .init(),
      cacheService: .init(),
      favouriteStore: .init()
    ))
  )
}
