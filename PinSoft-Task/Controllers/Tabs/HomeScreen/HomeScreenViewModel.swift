//
//  HomeScreenViewModel.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation
import UIKit

protocol HomeViewModelDelegate: AnyObject, AlertDialogPresenter {
    func updateUI()
    func toggleNavigationBar(hidden: Bool, duration: Double)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var viewController: UIViewController? { get set }
    var displayedWeatherData: WeatherData { get }
    var allDataLoaded: Bool { get }
    func fetchWeatherData()
    func loadMoreWeatherData()
    func refreshWeatherData()
    func scrollViewDidScroll(offsetY: CGFloat, contentHeight: CGFloat, screenHeight: CGFloat, spinner: UIActivityIndicatorView)
}

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewModelDelegate?
    weak var viewController: UIViewController?
    private var networkManager: NetworkManager
    private var allWeatherData: WeatherData = []
    var displayedWeatherData: WeatherData = []
    private let batchSize = 10
    private var offset = 0
    var isNavBarHidden: Bool = false
    
    var allDataLoaded: Bool {
        return offset >= allWeatherData.count
    }

    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    func fetchWeatherData() {
        guard let viewController = self.viewController else { return }
        
        if networkManager.isConnected {
            let endpoint = Endpoint.getWeathers
            networkManager.request(endpoint: endpoint) { [weak self] data, error in
                guard let self = self else { return }
                if let error = error {
                    self.delegate?.presentAlertDialog(message: error.localizedDescription, in: viewController)
                    return
                }
                
                guard let data = data else {
                    self.delegate?.presentAlertDialog(message: NetworkError.noData.localizedDescription, in: viewController)
                    return
                }

                do {
                    self.allWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    self.loadMoreWeatherData()
                } catch {
                    self.delegate?.presentAlertDialog(message: NetworkError.decodingError.localizedDescription, in: viewController)
                }
            }
        } else {
            DispatchQueue.main.async {
                self.delegate?.presentAlertDialog(message: NetworkError.noInternet.localizedDescription, in: viewController)
            }
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
}
