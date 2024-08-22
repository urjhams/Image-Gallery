//
//  DataError.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
  case badURL
  case invalidResponse
  
  var errorDescription: String? {
    switch self {
    case .badURL:
      return "The URL is invalid."
    case .invalidResponse:
      return "The server response was invalid."
    }
  }
}
