//
//  HomeScreenViewModel.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation
import UIKit

protocol HomeViewModelProtocol: BaseViewModelProtocol {
    var displayedWeatherData: WeatherData { get }
    var allDataLoaded: Bool { get }
    
    func fetchWeatherData()
    func loadMoreWeatherData()
    func refreshWeatherData()
    func scrollViewDidScroll(offsetY: CGFloat, contentHeight: CGFloat, screenHeight: CGFloat, spinner: UIActivityIndicatorView)
}

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: BaseViewModelDelegate?
    weak var viewController: UIViewController?
    private var networkManager: NetworkManager
    private var allWeatherData: WeatherData = []
    var displayedWeatherData: WeatherData = []
    private let batchSize = 10
    private var offset = 0
    var isNavBarHidden: Bool = false
    var favoriteViewModel = FavoriteViewModel()
    
    var allDataLoaded: Bool {
        return offset >= allWeatherData.count
    }

    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchWeatherData() {
        guard let viewController = self.viewController else { return }

        if networkManager.isConnected {
            networkManager.request(endpoint: Endpoint.getWeathers) { [weak self] data, error in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let data = data {
                        self.handleNetworkResponse(data: data, error: error, vc: viewController)
                    } else {
                        self.delegate?.presentAlertDialog(message: error?.localizedDescription ?? NetworkError.noData.localizedDescription, in: viewController)
                    }
                }
            }
        } else {
            delegate?.presentAlertDialog(message: NetworkError.noInternet.localizedDescription, in: viewController)
            loadWeatherDataFromUserDefaults(vc: viewController)
        }
    }

    private func loadWeatherDataFromUserDefaults(vc: UIViewController) {
        guard let data = UserDefaults.standard.data(forKey: AppConstants.UserDefaultsKeys.weatherDatas) else {
            delegate?.presentAlertDialog(message: NetworkError.noDataAvailable.localizedDescription, in: vc)
            return
        }

        do {
            self.allWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            self.refreshWeatherData()
        } catch {
            delegate?.presentAlertDialog(message: NetworkError.decodingError.localizedDescription, in: vc)
        }
    }
    
    private func handleNetworkResponse(data: Data?, error: Error?, vc: UIViewController) {
        
        guard let data = data else {
            delegate?.presentAlertDialog(message: error?.localizedDescription ?? NetworkError.noData.localizedDescription, in: vc)
            return
        }
        do {
            self.allWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            UserDefaults.standard.set(data, forKey: AppConstants.UserDefaultsKeys.weatherDatas)
            self.refreshWeatherData()
        } catch {
            delegate?.presentAlertDialog(message: NetworkError.decodingError.localizedDescription, in: vc)
        }
    }
    
    func loadMoreWeatherData() {
        let endIndex = min(offset + batchSize, allWeatherData.count)
        let newItems = allWeatherData[offset..<endIndex]
        displayedWeatherData.append(contentsOf: newItems)
        offset = endIndex
        delegate?.updateUI()
    }
    
    func refreshWeatherData() {
        offset = 0
        displayedWeatherData.removeAll()
        loadMoreWeatherData()
    }

    func filterWeatherData(by query: String) {
        if query.isEmpty {
            refreshWeatherData()
        } else {
            displayedWeatherData = allWeatherData.filter { weatherData in
                return weatherData.city.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
            }
        }
        delegate?.updateUI()
    }
    
    func scrollViewDidScroll(offsetY: CGFloat, contentHeight: CGFloat, screenHeight: CGFloat, spinner: UIActivityIndicatorView) {
        if offsetY > 20 && !isNavBarHidden {
            isNavBarHidden = true
            delegate?.updateUI()
            UIView.animate(withDuration: 1) {
                self.delegate?.toggleNavigationBar(hidden: true, duration: 1)
            }
        } else if offsetY <= 0 && isNavBarHidden {
            isNavBarHidden = false
            delegate?.updateUI()
            UIView.animate(withDuration: 1) {
                self.delegate?.toggleNavigationBar(hidden: false, duration: 1)
            }
        }
        
        if offsetY > contentHeight - screenHeight {
            if !allDataLoaded && !spinner.isAnimating {
                spinner.startAnimating()
                Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(loadMoreData), userInfo: nil, repeats: false)
            }
        }
    }

    @objc private func loadMoreData() {
        loadMoreWeatherData()
    }

    func toggleNavBar() -> Bool {
        return !isNavBarHidden
    }
    
    func toggleFavorite(at index: Int) {
        let item = displayedWeatherData[index]
        if (favoriteViewModel.favorites.first(where: { $0.id == item.id }) != nil) {
            favoriteViewModel.removeFavorite(item)
        } else {
            favoriteViewModel.addFavorite(item)
        }
        delegate?.favoritesDidUpdate()
    }
    
    func checkForFavoriteUpdates() {
        favoriteViewModel.loadFavorites()
        delegate?.updateUI()
    }
}
