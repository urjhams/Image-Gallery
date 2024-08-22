//
//  DataError.swift
//  Image Gallery
//
//  Created by Quân Đinh on 22.08.24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
  case badURL
  case requestFailed(error: Error)
  case invalidResponse
  case decodingError(error: Error)
  case unauthorized
  case forbidden
  case notFound
  case serverError(statusCode: Int)
  case noData
  case noInternetConnection
  case timeout
  case unknownError
  
  var errorDescription: String? {
    switch self {
    case .badURL:
      return "The URL is invalid."
    case .requestFailed(let error):
      return "The network request failed: \(error.localizedDescription)"
    case .invalidResponse:
      return "The server response was invalid."
    case .decodingError(let error):
      return "Failed to decode the response: \(error.localizedDescription)"
    case .unauthorized:
      return "You are not authorized to perform this action."
    case .forbidden:
      return "Access to this resource is forbidden."
    case .notFound:
      return "The requested resource was not found."
    case .serverError(let statusCode):
      return "The server returned an error with status code \(statusCode)."
    case .noData:
      return "The response from the server was empty."
    case .noInternetConnection:
      return "No internet connection is available."
    case .timeout:
      return "The request timed out."
    case .unknownError:
      return "An unknown error occurred."
    }
  }
}
