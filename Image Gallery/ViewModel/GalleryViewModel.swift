//
//  GalleryViewModel.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI

typealias Repository = CacheService & FavouriteService & DownloadService

@Observable
class GalleryViewModel {
  var images: [Image] = []
  private let repository: Repository
  
  init(repository: Repository) {
    self.repository = repository
  }
  
  @MainActor
  func loadImages() async throws {
    let images = try await repository.fetchImages()
    self.images = images
  }
  
  func toggleFavourite(_ image: Image) {
    if isFavourite(image) {
      repository.removeImage(for: "\(image.id)")
    } else {
      if let data = try? JSONEncoder().encode(image) {
        repository.setImage(data, for: "\(image.id)")
      }
    }
  }
  
  func isFavourite(_ image: Image) -> Bool {
    guard let _ = repository.getImage(for: "\(image.id)") else {
      return false
    }
    return true
  }
}
