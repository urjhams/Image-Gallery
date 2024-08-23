//
//  GalleryViewModelTests.swift
//  Image GalleryTests
//
//  Created by Quân Đinh on 23.08.24.
//

import XCTest
@testable import Image_Gallery
import SwiftData

class MockRepository: Repository {
  
  @MainActor
  var favouriteStore = FavouriteImageStore()
    
  var downloader = ImageDownloader()
  
  var mockImages: [Image] = []
    
  @MainActor func addFavourite(_ image: ImageEntity, in context: ModelContext) {
    favouriteStore.addFavourite(image, context: context)
  }
  
  @MainActor func removeFavourite(id: Int, in context: ModelContext) {
    favouriteStore.removeFavourite(id: id, context: context)
  }
  
  @MainActor func isFavourite(id: Int, in context: ModelContext) -> Bool {
    favouriteStore.isFavourite(id: id, context: context)
  }
  
  @MainActor func fetchFavourites(in context: ModelContext) throws -> [ImageEntity] {
    try favouriteStore.fetchFavourites(context: context)
  }
  
  @MainActor func syncFavourites(from fetchedImages: [Image], in context: ModelContext) throws {
    try favouriteStore.syncFavourites(from: fetchedImages, context: context)
  }
  
  @MainActor func toggleFavourite(_ image: ImageEntity, in context: ModelContext) {
    favouriteStore.toggleFavourite(image, context: context)
  }
  
  func fetchImages() async throws -> [Image] {
    mockImages
  }
  
  func getImage(from url: URL) async throws -> Data {
    try JSONEncoder().encode(mockImages.first!)
  }

}

final class GalleryViewModelTests: XCTestCase {
  
  var context: ModelContext!
  
  var viewModel: GalleryViewModel!
  var mock: MockRepository!
  
  @MainActor
  override func setUpWithError() throws {
    try super.setUpWithError()
    mock = MockRepository()
    viewModel = GalleryViewModel(repository: mock)
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
  
  func testLoadPhotoSuccess() async throws {
    mock.mockImages = [
      Image(id: 1, albumId: 1, title: "Photo 1", url: "url1", thumbnailUrl: "thumb1")
    ]
    
    try await viewModel.loadImages()
    XCTAssertEqual(viewModel.images.count, 1)
    XCTAssertEqual(viewModel.images.first?.title, "Photo 1")
  }
  
  func testToogleFavourite() {
    let image = Image(id: 1, albumId: 1, title: "Photo 1", url: "url1", thumbnailUrl: "thumb1")
    
    // Initially, it should not be a favourite
    XCTAssertFalse(viewModel.isFavourite(id: image.id, in: context))
    
    // Toggle favourite to add
    viewModel.toggleFavourite(.init(from: image), in: context)
    XCTAssertTrue(viewModel.isFavourite(id: image.id, in: context))
    
    // Toggle favourite to remove
    viewModel.toggleFavourite(.init(from: image), in: context)
    XCTAssertFalse(viewModel.isFavourite(id: image.id, in: context))
  }
  
}
