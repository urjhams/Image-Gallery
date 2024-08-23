//
//  TabView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 23.08.24.
//

import SwiftUI

struct ContainerView: View {
  @Environment(\.modelContext) private var modelContext
  
  @State var repository = ImageRepository(
    downloader: ImageDownloader(),
    cacheService: ImageCacheService(),
    favouriteStore: FavouriteImageStore()
  )
  
  var body: some View {
    TabView {
      GalleryView(viewModel: .init(repository: repository))
        .tabItem {
          Label("Gallery", systemImage: "photo.stack")
        }
    }
  }
}

#Preview {
  ContainerView()
}
