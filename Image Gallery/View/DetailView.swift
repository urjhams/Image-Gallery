//
//  DetailView.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI
import CachedAsyncImage

struct DetailView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(ImageRepository.self) private var repository
  let image: ImageEntity
  @State var isFavourte = false
  
  var body: some View {
    NavigationView {
      if let url = URL(string: image.url) {
        CachedAsyncImage(url: url) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
        }
      }
    }
    .onAppear {
      isFavourte = repository.isFavourite(id: image.id, in: modelContext)
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(
          "",
          systemImage: isFavourte ? "heart.fill" : "heart"
        ) {
          repository.toggleFavourite(image, in: modelContext)
          isFavourte = repository.isFavourite(id: image.id, in: modelContext)
        }
      }
    }
  }
}

#Preview {
  @State var repo = ImageRepository(downloader: .init(), favouriteStore: .init())
  return DetailView(
    image: .init(
      from: .init(
        id: 1,
        albumId: 1,
        title: "bullElk",
        url: Bundle.main.url(forResource: "bullElk", withExtension: "jpg")!.absoluteString,
        thumbnailUrl: "https://sample-rul.com")
    )
  )
  .environment(repo)
}
