//
//  FavouriteViewModelTests.swift
//  Image GalleryTests
//
//  Created by Quân Đinh on 23.08.24.
//

import XCTest
@testable import Image_Gallery
import SwiftData

final class FavouriteViewModelTests: XCTestCase {
  
  var context: ModelContext!
  
  var viewModel: FavouriteViewModel!
  var mock: MockRepository!
  
  @MainActor override func setUpWithError() throws {
    try super.setUpWithError()
    mock = MockRepository()
    viewModel = FavouriteViewModel(service: mock)
    let container = try! ModelContainer(
      for: ImageEntity.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    context = container.mainContext
  }
  
  override func tearDownWithError() throws {
    viewModel = nil
    mock = nil
    try super.tearDownWithError()
  }
  
  @MainActor
  func testloadFavourites() throws {
    let image = Image(id: 1, albumId: 1, title: "Photo 1", url: "url1", thumbnailUrl: "thumb1")
    
    // Toggle favourite to add
    mock.addFavourite(.init(from: image), in: context)
    
    viewModel.loadFavourite(in: context)
    
    XCTAssertEqual(viewModel.favourites.count, 1)
    XCTAssertEqual(viewModel.favourites.first?.id, 1)
  }
}
