//
//  ImageRepository.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

protocol CacheService {
  var cacheService: ImageCacheService { get }
  
  func getImage(for key: String) -> Data?
  func setImage(_ data: Data, for key: String)
  func removeImage(for key: String)
}

extension CacheService {
  func getImage(for key: String) -> Data? {
    cacheService.getImage(for: key)
  }
  
  func setImage(_ data: Data, for key: String) {
    cacheService.setImage(data, for: key)
  }
  
  func removeImage(for key: String) {
    cacheService.removeImage(for: key)
  }
}

protocol DownloadService {
  var downloader: ImageDownloader { get }
  
  func fetchImages() async throws -> [Image]
  func getImage(from url: URL) async throws -> Data
}

protocol FavouriteService {
  var favouriteStore: FavouriteImageStore { get }
  
  func addFavourite(_ image: Image, in context: ModelContext)
  
  func removeFavourite(_ image: ImageEntity, in context: ModelContext)
  
  func isFavourite(_ image: Image, in context: ModelContext) -> Bool
  
  func fetchFavourites(in context: ModelContext) throws -> [ImageEntity]
  
  func syncFavourites(from fetchedImages: [Image], in context: ModelContext) throws
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
  func addFavourite(_ image: Image, in context: ModelContext) {
    favouriteStore.addFavourite(image, context: context)
  }
  
  func removeFavourite(_ image: ImageEntity, in context: ModelContext) {
    favouriteStore.removeFavourite(image, context: context)
  }
  
  func isFavourite(_ image: Image, in context: ModelContext) -> Bool {
    favouriteStore.isFavourite(image, context: context)
  }
  
  func fetchFavourites(in context: ModelContext) throws -> [ImageEntity] {
    try favouriteStore.fetchFavourites(context: context)
  }
  
  func syncFavourites(from fetchedImages: [Image], in context: ModelContext) throws {
    try favouriteStore.syncFavourites(from: fetchedImages, context: context)
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
