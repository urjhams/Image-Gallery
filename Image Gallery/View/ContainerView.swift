//
//  TabView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 23.08.24.
//

import SwiftUI

struct ContainerView: View {
  @Environment(\.modelContext) private var modelContext
  
  @Environment(ImageRepository.self) private var repository
  
  var body: some View {
    TabView {
      GalleryView(viewModel: .init(repository: repository))
        .tabItem {
          Label("Gallery", systemImage: "photo.stack")
        }
      
      FavouriteView(viewModel: .init(service: repository))
        .tabItem {
          Label("Favourite", systemImage: "heart.circle")
        }
    }
  }
}

#Preview {
  ContainerView()
}
