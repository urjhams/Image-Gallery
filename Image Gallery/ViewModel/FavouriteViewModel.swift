//
//  FavouriteViewModel.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import SwiftUI
import SwiftData

@Observable
class FavouriteViewModel {
  var favourites: [ImageEntity] = []
  let service: FavouriteService
  
  init(service: any FavouriteService) {
    self.service = service
  }
  
  @MainActor
  func loadFavourite(in context: ModelContext) {
    do {
      favourites = try service.fetchFavourites(in: context)
    } catch {
      favourites = []
    }
  }
}
