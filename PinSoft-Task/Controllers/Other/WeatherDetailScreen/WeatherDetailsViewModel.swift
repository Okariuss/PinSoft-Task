//
//  WeatherDetailsViewModel.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 3.03.2024.
//

import Foundation

protocol WeatherDetailsViewModelDelegate: AnyObject, AlertDialogPresenter {
    func updateFavoriteStatus()
}

class WeatherDetailsViewModel {
    
    let weatherInfo: WeatherInfo
    
    lazy var isFavorite: Bool = loadFavoriteStatus()
    
    init(weatherInfo: WeatherInfo) {
        self.weatherInfo = weatherInfo
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        saveFavoriteStatus()
    }
    
    private func saveFavoriteStatus() {
        var favorites = loadFavorites()
        if isFavorite {
            favorites.append(weatherInfo)
        } else {
            favorites.removeAll { $0.id == weatherInfo.id }
        }
        UserDefaults.standard.set(try? JSONEncoder().encode(favorites), forKey: AppConstants.UserDefaultsKeys.favorites)
    }
    
    private func loadFavoriteStatus() -> Bool {
        guard let favoritesData = UserDefaults.standard.data(forKey: AppConstants.UserDefaultsKeys.favorites),
              let favorites = try? JSONDecoder().decode(WeatherData.self, from: favoritesData) else {
            return false
        }
        return favorites.contains(where: { $0.id == weatherInfo.id })
    }
    
    private func loadFavorites() -> [WeatherInfo] {
        guard let favoritesData = UserDefaults.standard.data(forKey: AppConstants.UserDefaultsKeys.favorites),
              let favorites = try? JSONDecoder().decode(WeatherData.self, from: favoritesData) else {
            return []
        }
        return favorites
    }
}
