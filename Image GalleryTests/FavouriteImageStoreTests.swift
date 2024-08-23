//
//  FavouriteImageStoreTests.swift
//  Image GalleryTests
//
//  Created by Quân Đinh on 22.08.24.
//

import XCTest
@testable import Image_Gallery
import SwiftData

final class FavouriteImageStoreTests: XCTestCase {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  
  var container: ModelContainer!
  
  var sut: ImageRepository!
  
  let img1 = Image(
    id: 1,
    albumId: 1,
    title: "Test Image",
    url: "https://example.com/image",
    thumbnailUrl: "https://example.com/thumb"
  )
  
  let img2 = Image(
    id: 2,
    albumId: 1,
    title: "Test Image 2",
    url: "https://example.com/image2",
    thumbnailUrl: "https://example.com/thumb"
  )
  
  @MainActor
  override func setUpWithError() throws {
    try super.setUpWithError()
    container = try ModelContainer(for: ImageEntity.self, configurations: config)
    sut = ImageRepository(
      downloader: ImageDownloader(),
      cacheService: ImageCacheService(), 
      favouriteStore: FavouriteImageStore()
    )
  }
  
  override func tearDownWithError() throws {
    container = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  @MainActor
  func testFetchEmpty() throws {
    let favourites = try sut.fetchFavourites(in: container.mainContext)
    XCTAssertEqual(favourites.count, 0)
  }
  
  @MainActor
  func testAddFavourite() throws {

    sut.addFavourite(img1, in: container.mainContext)
    
    var favourites = try sut.fetchFavourites(in: container.mainContext)
    
    XCTAssertEqual(favourites.count, 1)
    XCTAssertEqual(favourites.first?.id, img1.id)
    XCTAssertEqual(favourites.first?.title, img1.title)
        
    sut.addFavourite(img2, in: container.mainContext)
    
    favourites = try sut.fetchFavourites(in: container.mainContext)
    
    XCTAssertEqual(favourites.count, 2)
  }
  
  @MainActor
  func testRemoveFavourite() throws {
    
    sut.addFavourite(img1, in: container.mainContext)
    
    sut.addFavourite(img2, in: container.mainContext)
    var favourites = try sut.fetchFavourites(in: container.mainContext)
    XCTAssertEqual(favourites.count, 2)
    
    sut.removeFavourite(favourites.first!, in: container.mainContext)
    favourites = try sut.fetchFavourites(in: container.mainContext)
    
    XCTAssertEqual(favourites.count, 1)
    XCTAssertEqual(favourites.first?.id, img2.id)
    XCTAssertEqual(favourites.first?.title, img2.title)
  }
  
  @MainActor
  func testIsFavourite() throws {
    
    XCTAssertFalse(sut.isFavourite(img1, in: container.mainContext))
    
    sut.addFavourite(img1, in: container.mainContext)
    
    XCTAssertTrue(sut.isFavourite(img1, in: container.mainContext))
  }
  
  @MainActor
  func testSyncFavourite() throws {
    sut.addFavourite(img1, in: container.mainContext)
    var favourites = try sut.fetchFavourites(in: container.mainContext)
    XCTAssertEqual(favourites.first?.title, img1.title)
    
    var copy = img1
    copy.title = "new title image"
    try sut.syncFavourites(from: [copy], in: container.mainContext)
    favourites = try sut.fetchFavourites(in: container.mainContext)
    XCTAssertEqual(favourites.first?.title, "new title image")
  }
  
}
