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

  var cacheService: ImageCacheService!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    cacheService = ImageCacheService()
  }
  
  override func tearDownWithError() throws {
    cacheService = nil
    try super.tearDownWithError()
  }
  
  func testSetAndGetImage() {
    let data = Data([0, 1, 2, 3])
    cacheService.setImage(data, for: "testKey")
    
    let cachedData = cacheService.getImage(for: "testKey")
    XCTAssertEqual(cachedData, data)
  }
  
  func testGetImageNotInCache() {
    let cachedData = cacheService.getImage(for: "nonexistentKey")
    XCTAssertNil(cachedData)
  }
}
