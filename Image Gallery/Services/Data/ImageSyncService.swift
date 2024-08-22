//
//  ImageSyncService.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation
import SwiftData

@MainActor
class ImageSyncService {
  private let context: ModelContext
  
  init(context: ModelContext) {
    self.context = context
  }
}
