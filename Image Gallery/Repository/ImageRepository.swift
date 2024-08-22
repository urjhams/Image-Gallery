//
//  ImageRepository.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

class ImageRepository {
  private let downloader: ImageDownloader
  private let cacheService: ImageCacheService
  private let favouriteStore: FavouriteImageStore
  private let syncService: ImageSyncService
  
  init(
    downloader: ImageDownloader,
    cacheService: ImageCacheService,
    favouriteStore: FavouriteImageStore,
    syncService: ImageSyncService
  ) {
    self.downloader = downloader
    self.cacheService = cacheService
    self.favouriteStore = favouriteStore
    self.syncService = syncService
  }
}

/// favourite storage
@MainActor
extension ImageRepository {
  func addFavourite(_ image: any ImageInterface) {
    favouriteStore.addFavourite(image)
  }
  
  func removeFavourite(_ image: ImageEntity) {
    favouriteStore.removeFavourite(image)
  }
  
  func isFavourite(_ image: any ImageInterface) -> Bool {
    favouriteStore.isFavourite(image)
  }
  
  func fetchFavourites() throws -> [ImageEntity] {
    try favouriteStore.fetchFavourites()
  }
}

/// network service
extension ImageRepository {
  
}

/// sync service
extension ImageRepository {
  
}
