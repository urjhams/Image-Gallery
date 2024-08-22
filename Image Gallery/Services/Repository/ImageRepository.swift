//
//  ImageRepository.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

protocol Repository {
  var downloader: ImageDownloader { get }
  var cacheService: ImageCacheService { get }
  var favouriteStore: FavouriteImageStore { get }
  var syncService: ImageSyncService { get }
}

class ImageRepository: Repository {
  internal let downloader: ImageDownloader
  internal let cacheService: ImageCacheService
  internal let favouriteStore: FavouriteImageStore
  internal let syncService: ImageSyncService
  
  private let decoder = JSONDecoder()
  
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

/// download service
extension ImageRepository {
  func fetchImages() async throws -> [Image] {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
      throw NetworkError.badURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.invalidResponse
    }
    
    return try decoder.decode([Image].self, from: data)
  }
  
  func getImage(from url: URL) async throws -> Data {
    try await downloader.downloadImage(from: url)
  }
}

/// sync service
extension ImageRepository {
  
}
