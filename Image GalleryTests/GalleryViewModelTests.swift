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
  var favouriteStore: FavouriteImageStore = {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ImageEntity.self, configurations: config)
    return FavouriteImageStore(context: container.mainContext)
  }()
  
  var cacheService = ImageCacheService()
  
  var downloader = ImageDownloader()
  
  var mockImages: [Image] = []
  
  var container: ModelContainer!
  
    
  @MainActor func addFavourite(_ image: Image) {
    favouriteStore.addFavourite(image)
  }
  
  @MainActor func removeFavourite(_ image: ImageEntity) {
    favouriteStore.removeFavourite(image)
  }
  
  @MainActor func isFavourite(_ image: Image) -> Bool {
    favouriteStore.isFavourite(image)
  }
  
  @MainActor func fetchFavourites() throws -> [ImageEntity] {
    try favouriteStore.fetchFavourites()
  }
  
  @MainActor func syncFavourites(from fetchedImages: [Image]) throws {
    try favouriteStore.syncFavourites(from: fetchedImages)
  }
  
  func fetchImages() async throws -> [Image] {
    mockImages
  }
  
  func getImage(from url: URL) async throws -> Data {
    try JSONEncoder().encode(mockImages.first!)
  }

}

final class GalleryViewModelTests: XCTestCase {
  
  var viewModel: GalleryViewModel!
  var mock: MockRepository!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    mock = MockRepository()
    viewModel = GalleryViewModel(repository: mock)
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
    
    print("-------", mock.mockImages)
    try await viewModel.loadImages()
    print("-------", viewModel.images)
    XCTAssertEqual(viewModel.images.count, 1)
    XCTAssertEqual(viewModel.images.first?.title, "Photo 1")
  }
  
  func testToogleFavourite() {
    let image = Image(id: 1, albumId: 1, title: "Photo 1", url: "url1", thumbnailUrl: "thumb1")
    
    // Initially, it should not be a favourite
    XCTAssertFalse(viewModel.isFavourite(image))
    
    // Toggle favourite to add
    viewModel.toggleFavourite(image)
    XCTAssertTrue(viewModel.isFavourite(image))
    
    // Toggle favourite to remove
    viewModel.toggleFavourite(image)
    XCTAssertFalse(viewModel.isFavourite(image))
  }
  
}
