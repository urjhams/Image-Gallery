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
  @State var isFavourite = false
  
  var body: some View {
    VStack {
      if let url = URL(string: image.url) {
        CachedAsyncImage(url: url) { image in
          image
            .resizable()
            .scaledToFit()
        } placeholder: {
          ProgressView()
        }
      } else {
        Spacer()
      }
      
      Button(
        "",
        systemImage: isFavourite ? "heart.fill" : "heart"
      ) {
        repository.toggleFavourite(image, in: modelContext)
        isFavourite = repository.isFavourite(id: image.id, in: modelContext)
      }
      .font(.largeTitle)
      .padding()
    }
//    .toolbar {
//      ToolbarItem(placement: .navigationBarTrailing) {
//        Button(
//          "",
//          systemImage: isFavourite ? "heart.fill" : "heart"
//        ) {
//          repository.toggleFavourite(image, in: modelContext)
//          isFavourite = repository.isFavourite(id: image.id, in: modelContext)
//        }
//      }
//    }
    
    .onAppear {
      isFavourite = repository.isFavourite(id: image.id, in: modelContext)
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
