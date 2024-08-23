//
//  FavouriteImageStore.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

class FavouriteImageStore {
  func addFavourite(_ image: Image, context: ModelContext) {
    let entity = ImageEntity(from: image)
    context.insert(entity)
    try? context.save()
  }
  
  func removeFavourite(_ image: ImageEntity, context: ModelContext) {
    context.delete(image)
    try? context.save()
  }
  
  func isFavourite(_ image: Image, context: ModelContext) -> Bool {
    let id = image.id
    let predicate = #Predicate<ImageEntity> { $0.id == id }
    var descriptor = FetchDescriptor<ImageEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    guard let result = try? context.fetch(descriptor), result.count == 1 else {
      return false
    }
    
    return true
  }
  
  func fetchFavourites(context: ModelContext) throws -> [ImageEntity] {
    let descriptor = FetchDescriptor<ImageEntity>()
    return try context.fetch(descriptor)
  }
  
  func syncFavourites(from fetchedImages: [Image], context: ModelContext) throws {
    let currentFavourites = try fetchFavourites(context: context)
    let currentIds = currentFavourites.map(\.id)
    
    fetchedImages
      .filter { currentIds.contains($0.id) }
      .map(ImageEntity.init)
      .forEach { context.insert($0) }
    
    try context.save()
  }
  
}
