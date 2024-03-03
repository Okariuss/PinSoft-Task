//
//  AppConstants.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 1.03.2024.
//

import Foundation

class AppConstants {
    
    enum SpaceConstants {
        case low
        case normal
        case medium
        case high
        
        var rawValue: CGFloat {
            switch self {
            case .low:
                return 4
            case .normal:
                return 8
            case .medium:
                return 12
            case .high:
                return 16
            }
        }
    }
    
    enum RadiusConstants {
        case low
        case normal
        case medium
        case high
        
        var rawValue: CGFloat {
            switch self {
            case .low:
                return 5
            case .normal:
                return 10
            case .medium:
                return 15
            case .high:
                return 20
            }
        }
    }
    
    final class NetworkConstants {
        private init() {}
        
        static let baseURL = "https://freetestapi.com/api/v1/"
        static let weather = "weathers"
    }
    
    final class UserDefaultsKeys {
        private init() {}
        
        static let favorites = "Favorites"
    }
    
    final class CellIdentifiers {
        private init() {}
        
        static let weatherInfoCellIdentifier = "WeatherInfoCell"
    }
    
    final class LocalizationConstants {
        private init() {}
        
        static let weatherTitle = "Weather"
        static let favoriteTitle = "Favorites"
        static let weatherSearchBarPlaceholder = "Search for a city"
    }
}
