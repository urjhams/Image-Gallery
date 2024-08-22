//
//  ImageRepository.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

protocol CacheService {
  var cacheService: ImageCacheService { get }
  
  func getImage(for key: String) -> Data?
  func setImage(_ data: Data, for key: String)
}

extension CacheService {
  func getImage(for key: String) -> Data? {
    cacheService.getImage(for: key)
  }
  
  func setImage(_ data: Data, for key: String) {
    cacheService.setImage(data, for: key)
  }
}

protocol DownloadService {
  var downloader: ImageDownloader { get }
  
  func fetchImages() async throws -> [Image]
  func getImage(from url: URL) async throws -> Data
}

protocol FavouriteService {
  var favouriteStore: FavouriteImageStore { get }
  
  func addFavourite(_ image: any ImageInterface)
  
  func removeFavourite(_ image: ImageEntity)
  
  func isFavourite(_ image: any ImageInterface) -> Bool
  
  func fetchFavourites() throws -> [ImageEntity]
  
  func syncFavourites(from fetchedImages: [any ImageInterface]) throws
}

class ImageRepository: CacheService, FavouriteService, DownloadService {
  internal let downloader: ImageDownloader
  internal let cacheService: ImageCacheService
  internal let favouriteStore: FavouriteImageStore
  
  private let decoder = JSONDecoder()
  
  init(
    downloader: ImageDownloader,
    cacheService: ImageCacheService,
    favouriteStore: FavouriteImageStore
  ) {
    self.downloader = downloader
    self.cacheService = cacheService
    self.favouriteStore = favouriteStore
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
  
  func syncFavourites(from fetchedImages: [any ImageInterface]) throws {
    try favouriteStore.syncFavourites(from: fetchedImages)
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
