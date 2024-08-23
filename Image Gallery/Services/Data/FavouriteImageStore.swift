//
//  FavouriteImageStore.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

class FavouriteImageStore {
  func addFavourite(_ image: ImageEntity, context: ModelContext) {
    context.insert(image)
    try? context.save()
  }
  
  func removeFavourite(id: Int, context: ModelContext) {
    let predicate = #Predicate<ImageEntity> { $0.id == id }
    var descriptor = FetchDescriptor<ImageEntity>(predicate: predicate)
    descriptor.fetchLimit = 1
    guard let result = try? context.fetch(descriptor), let img = result.first else {
      return
    }
    context.delete(img)
    try? context.save()
  }
  
  func toggleFavourite(_ image: ImageEntity, context: ModelContext) {
    if isFavourite(id: image.id, context: context) {
      removeFavourite(id: image.id, context: context)
    } else {
      addFavourite(image, context: context)
    }
  }
  
  func isFavourite(id: Int, context: ModelContext) -> Bool {
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
