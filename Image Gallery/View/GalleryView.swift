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
            if let thumbURL = URL(string: img.thumbnailUrl) {
              NavigationLink {
                DetailView(image: .init(from: img))
              } label: {
                ItemView(size: 100, item: .init(url: thumbURL))
                  .cornerRadius(20)
              }
            }
          }
        }
      }
      .refreshable {
        try? await viewModel.loadImages()
      }
      .navigationViewStyle(StackNavigationViewStyle())
      .navigationTitle("Gallery")
      .task {
        try? await viewModel.loadImages()
      }
    }
  }
}

#Preview {
  @State var repo = ImageRepository(downloader: .init(), favouriteStore: .init())
  return GalleryView(viewModel: GalleryViewModel(
    repository: ImageRepository(
      downloader: .init(),
      favouriteStore: .init()
    ))
  )
  .environment(repo)
}
