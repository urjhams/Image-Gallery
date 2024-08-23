//
//  ImageCacheServiceTests.swift
//  Image GalleryTests
//
//  Created by Quân Đinh on 22.08.24.
//

import XCTest
@testable import Image_Gallery
import SwiftData

final class ImageCacheServiceTests: XCTestCase {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  

  var sut: CacheService!
  
  @MainActor
  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = ImageRepository(
      downloader: ImageDownloader(),
      cacheService: ImageCacheService(),
      favouriteStore: FavouriteImageStore()
    )
  }
  
  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }
  
  func testSetAndGetImage() {
    let data = Data([0, 1, 2, 3])
    sut.setImage(data, for: "testKey")
    
    let cachedData = sut.getImage(for: "testKey")
    XCTAssertEqual(cachedData, data)
  }
  
  func testGetImageNotInCache() {
    let cachedData = sut.getImage(for: "nonexistentKey")
    XCTAssertNil(cachedData)
  }
}
