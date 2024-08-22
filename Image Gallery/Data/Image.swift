//
//  Image.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

struct Image: Identifiable, Codable {
  let id: Int
  let albumId: Int
  let title: String
  let url: String
  let thumbnailUrl: String
}
