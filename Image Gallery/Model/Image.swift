//
//  Image.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

protocol ImageInterface: Identifiable {
  var id: Int { get }
  var title: String { get }
  var url: String { get }
  var thumbnailUrl: String { get }
}

struct Image: ImageInterface, Codable {
  var id: Int
  var albumId: Int
  var title: String
  var url: String
  var thumbnailUrl: String
}
