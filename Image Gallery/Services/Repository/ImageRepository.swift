//
//  ImageRepository.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

protocol DownloadService {
  var downloader: ImageDownloader { get }
  
  func fetchImages() async throws -> [Image]
  func getImage(from url: URL) async throws -> Data
}

protocol FavouriteService {
  var favouriteStore: FavouriteImageStore { get }
  
  func addFavourite(_ image: ImageEntity, in context: ModelContext)
  
  func removeFavourite(id: Int, in context: ModelContext)
  
  func toggleFavourite(_ image: ImageEntity, in context: ModelContext)
  
  func isFavourite(id: Int, in context: ModelContext) -> Bool
  
  func fetchFavourites(in context: ModelContext) throws -> [ImageEntity]
  
  func syncFavourites(from fetchedImages: [Image], in context: ModelContext) throws
}

@Observable
class ImageRepository: NSObject, FavouriteService, DownloadService {
  
  internal let downloader: ImageDownloader
  internal let favouriteStore: FavouriteImageStore
  
  private let decoder = JSONDecoder()
  
  init(
    downloader: ImageDownloader,
    favouriteStore: FavouriteImageStore
  ) {
    self.downloader = downloader
    self.favouriteStore = favouriteStore
  }
}

/// favourite storage
@MainActor
extension ImageRepository {
  func addFavourite(_ image: ImageEntity, in context: ModelContext) {
    favouriteStore.addFavourite(image, context: context)
  }
  
  func removeFavourite(id: Int, in context: ModelContext) {
    favouriteStore.removeFavourite(id: id, context: context)
  }
  
  func isFavourite(id: Int, in context: ModelContext) -> Bool {
    favouriteStore.isFavourite(id: id, context: context)
  }
  
  func fetchFavourites(in context: ModelContext) throws -> [ImageEntity] {
    try favouriteStore.fetchFavourites(context: context)
  }
  
  func syncFavourites(from fetchedImages: [Image], in context: ModelContext) throws {
    try favouriteStore.syncFavourites(from: fetchedImages, context: context)
  }
  
  func toggleFavourite(_ image: ImageEntity, in context: ModelContext) {
    favouriteStore.toggleFavourite(image, context: context)
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
