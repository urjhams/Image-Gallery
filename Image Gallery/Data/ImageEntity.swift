//
//  ImageEntity.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

@Model
class ImageEntity: Identifiable {
  @Attribute(.unique) var id: Int
  var title: String
  var url: String
  var thumbnailURL: String
  
  init(id: Int, title: String, url: String, thumbnailURL: String) {
    self.id = id
    self.title = title
    self.url = url
    self.thumbnailURL = thumbnailURL
  }
  
  init(from interface: any ImageInterface) {
    self.id = interface.id
    self.title = interface.title
    self.url = interface.url
    self.thumbnailURL = interface.thumbnailUrl
  }
}
