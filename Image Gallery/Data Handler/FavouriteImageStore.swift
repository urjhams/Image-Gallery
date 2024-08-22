//
//  FavouriteImageStore.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

@MainActor
class FavouriteImageStore {
  private let context: ModelContext
  
  init(context: ModelContext) {
    self.context = context
  }
  
  func addFavourite(_ image: any ImageInterface) {
    let entity = ImageEntity(from: image)
    context.insert(entity)
    try? context.save()
  }
  
  func removeFavourite(_ image: ImageEntity) {
    context.delete(image)
    try? context.save()
  }
  
  func isFavourite(_ image: Image) -> Bool {
    return false
  }
  
  func fetchFavourites() throws -> [ImageEntity] {
    let descriptor = FetchDescriptor<ImageEntity>()
    return try context.fetch(descriptor)
  }
}
