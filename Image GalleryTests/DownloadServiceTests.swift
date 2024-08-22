//
//  DownloadServiceTests.swift
//  Image GalleryTests
//
//  Created by Quân Đinh on 22.08.24.
//

import XCTest
@testable import Image_Gallery
import SwiftData

final class DownloadServiceTests: XCTestCase {
  
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  
  var container: ModelContainer!
  
  var sut: DownloadService!
  
  @MainActor
  override func setUpWithError() throws {
    try super.setUpWithError()
    container = try ModelContainer(for: ImageEntity.self, configurations: config)
    sut = ImageRepository(
      downloader: ImageDownloader(),
      cacheService: ImageCacheService(),
      favouriteStore: FavouriteImageStore(context: container.mainContext)
    )
  }
  
  override func tearDownWithError() throws {
    container = nil
    sut = nil
    try super.tearDownWithError()
  }
  
  func testFetchPhotos() async throws {
    let images = try await sut.fetchImages()
    
    XCTAssertTrue(images.count > 0)
  }
  
  func testDownloadImage() async throws {
    let images = try await sut.fetchImages()
    XCTAssertTrue(images.count > 0)
    
    let thumbnail = try? await sut.getImage(from: URL(string: images[0].thumbnailUrl)!)
    
    let image = try? await sut.getImage(from: URL(string: images[0].url)!)
    
    XCTAssertNotNil(thumbnail)
    
    XCTAssertNotNil(image)
  }
  
  func testDownloadImageFailed() async throws {
    let url = URL(string: "https://invalid-url.com")!
    
    do {
      _ = try await sut.getImage(from: url)
      XCTFail("Expected error to be thrown")
    } catch {
      XCTAssertTrue(true)
    }
  }
  
}
