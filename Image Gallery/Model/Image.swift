//
//  Image.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

struct Image: Identifiable, Codable {
  var id: Int
  var albumId: Int
  var title: String
  var url: String
  var thumbnailUrl: String
}
