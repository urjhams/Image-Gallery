//
//  TabView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 23.08.24.
//

import SwiftUI

struct ContainerView: View {
  @Environment(\.modelContext) private var modelContext
  
  @State var repository: ImageRepository = {
    .init(
      downloader: ImageDownloader(),
      cacheService: ImageCacheService(),
      favouriteStore: FavouriteImageStore()
    )
  }()
  
  @State var galleryViewModel: GalleryViewModel!
  
  init() {
    repository = .init(
      downloader: ImageDownloader(),
      cacheService: ImageCacheService(),
      favouriteStore: FavouriteImageStore()
    )

    galleryViewModel = .init(repository: repository)
  }
  
  var body: some View {
    TabView {
      if let model = galleryViewModel {
        GalleryView(viewModel: model)
          .tabItem {
            Label("Gallery", systemImage: "photo.stack")
          }
      }
    }
  }
}

#Preview {
  ContainerView()
}
