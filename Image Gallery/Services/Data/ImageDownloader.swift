//
//  ImageDownloader.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

actor ImageDownloader {
  func downloadImage(from url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      throw NetworkError.invalidResponse
    }
    
    return data
  }
}
