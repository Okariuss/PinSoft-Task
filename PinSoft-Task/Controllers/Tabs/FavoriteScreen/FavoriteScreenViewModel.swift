//
//  FavoriteScreenViewModel.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 2.03.2024.
//

import Foundation
import UIKit

protocol FavoriteViewModelProtocol: BaseViewModelProtocol {
    func loadFavorites()
    func addFavorite(_ item: WeatherInfo)
    func removeFavorite(_ item: WeatherInfo)
}

final class FavoriteViewModel: FavoriteViewModelProtocol {
    
    weak var delegate: BaseViewModelDelegate?
    weak var viewController: UIViewController?
    var isNavBarHidden: Bool = false

    var favorites: WeatherData = [] {
        didSet {
            delegate?.favoritesDidUpdate()
        }
    }

    init() {
        loadFavorites()
    }

    func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: AppConstants.UserDefaultsKeys.favorites) else { return }
        do {
            favorites = try JSONDecoder().decode(WeatherData.self, from: data)
        } catch {
            guard let viewController = self.viewController else { return }
            delegate?.presentAlertDialog(message: error.localizedDescription, in: viewController)
        }
    }

    func addFavorite(_ item: WeatherInfo) {
        if !favorites.contains(where: { $0.id == item.id }) {
            favorites.append(item)
            saveFavorites()
        }
    }

    func removeFavorite(_ item: WeatherInfo) {
        favorites.removeAll { $0.id == item.id }
        saveFavorites()
    }
    
    func toggleNavBar() -> Bool {
        return !isNavBarHidden
    }

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: AppConstants.UserDefaultsKeys.favorites)
            UserDefaults.standard.synchronize()
        } catch {
            guard let viewController = self.viewController else { return }
            delegate?.presentAlertDialog(message: error.localizedDescription, in: viewController)
        }
    }
}
