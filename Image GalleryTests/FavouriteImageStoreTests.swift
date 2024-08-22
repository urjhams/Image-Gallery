//
//  FavouriteImageStoreTests.swift
//  Image GalleryTests
//
//  Created by Quân Đinh on 22.08.24.
//

import XCTest
@testable import Image_Gallery
import SwiftData

@MainActor
final class FavouriteImageStoreTests: XCTestCase {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  
  var container: ModelContainer!
  
  var sut: FavouriteImageStore!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    container = try ModelContainer(for: ImageEntity.self, configurations: config)
    sut = FavouriteImageStore(context: container.mainContext)
  }
  
  override func tearDownWithError() throws {
    container = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    // Any test you write for XCTest can be annotated as throws and async.
    // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
    // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
  }
  
  func testFetchEmpty() throws {
    let favourites = try sut.fetchFavourites()
    XCTAssertEqual(favourites.count, 0)
  }
  
  func testAddFavourite() {
    let img = Image(
      id: 1,
      albumId: 1,
      title: "Test Image",
      url: "https://example.com/image",
      thumbnailUrl: "https://example.com/thumb"
    )
    
    sut.addFavourite(img)
    
//    let favourites = sut.fetchFavourites()
    
    
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}
