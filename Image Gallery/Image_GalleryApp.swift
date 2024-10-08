//
//  Image_GalleryApp.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI
import SwiftData

@main
struct Image_GalleryApp: App {
  var sharedModelContainer: ModelContainer = {
    let schema = Schema([ImageEntity.self,])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    
    do {
      return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
      fatalError("Could not create ModelContainer: \(error)")
    }
  }()
  
  @State var repository = ImageRepository(
    downloader: ImageDownloader(),
    favouriteStore: FavouriteImageStore()
  )
    
  var body: some Scene {
    WindowGroup {
      ContainerView()
    }
    .modelContainer(sharedModelContainer)
    .environment(repository)
  }
}
