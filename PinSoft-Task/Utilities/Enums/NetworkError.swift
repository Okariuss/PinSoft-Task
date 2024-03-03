//
//  NetworkError.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation

enum NetworkError: Error {
    case noInternet
    case noData
    case invalidURL
    case decodingError
    case noDataAvailable
    
    var localizedDescription: String {
        switch self {
        case .noInternet:
            return "No internet connection available."
        case .noData:
            return "No data available from the server."
        case .invalidURL:
            return "Invalid URL provided for network request."
        case .decodingError:
            return "Error occurred while decoding the response data."
        case .noDataAvailable:
            return "No cached weather data available."
        }
    }
}
