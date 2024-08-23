//
//  Item.swift
//  Image Gallery
//
//  Created by Quân Đinh on 23.08.24.
//

import SwiftUI

struct Item: Identifiable {
  let id = UUID()
  let url: URL
}

extension Item: Equatable {
  static func ==(lhs: Item, rhs: Item) -> Bool {
    lhs.id == rhs.id && lhs.id == rhs.id
  }
}

