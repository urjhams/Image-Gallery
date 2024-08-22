//
//  ImageCacheService.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

actor ImageCacheService {
  private let cache = NSCache<NSString, NSData>()
  
  func getImage(for key: String) -> Data? {
    cache.object(forKey: key as NSString) as? Data
  }
  
  func setImage(_ data: Data, for key: String) {
    cache.setObject(data as NSData, forKey: key as NSString)
  }
}
