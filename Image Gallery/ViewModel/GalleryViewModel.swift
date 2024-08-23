//
//  GalleryViewModel.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI
import SwiftData

typealias Repository = FavouriteService & DownloadService

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
  
  func loadFavourite() {
    
  }
  
  func toggleFavourite(_ image: Image, in context: ModelContext) {
    if isFavourite(image, in: context) {
      repository.removeFavourite(id: image.id, in: context)
    } else {
      repository.addFavourite(image, in: context)
    }
  }
  
  func isFavourite(_ image: Image, in context: ModelContext) -> Bool {
    repository.isFavourite(image, in: context)
  }
}
