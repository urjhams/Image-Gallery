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
  
  init(from interface: any ImageInterface) {
    self.id = interface.id
    self.title = interface.title
    self.url = interface.url
    self.thumbnailURL = interface.thumbnailUrl
  }
}
