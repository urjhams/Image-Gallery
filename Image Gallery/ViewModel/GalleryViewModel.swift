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
  let repository: Repository
  
  init(repository: Repository) {
    self.repository = repository
  }
  
  @MainActor
  func loadImages() async throws {
    let images = try await repository.fetchImages()
    self.images = images
  }
  
  func toggleFavourite(_ image: ImageEntity, in context: ModelContext) {
    repository.toggleFavourite(image, in: context)
  }
  
  func isFavourite(id: Int, in context: ModelContext) -> Bool {
    repository.isFavourite(id: id, in: context)
  }
}
