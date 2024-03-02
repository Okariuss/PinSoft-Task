//
//  NetworkManager.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import Foundation
import Network

class NetworkManager {
    
    static let shared = NetworkManager()

    private let monitor = NWPathMonitor()
    
    private init() {
        startMonitoring()
    }
    
    var isConnected: Bool {
        return isConnectedToWiFi
    }
    
    func request(endpoint: Endpoint, completion: @escaping (Data?, Error?) -> Void) {
        let request = endpoint.request()

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }

        dataTask.resume()
    }
    
    private var isConnectedToWiFi: Bool = false
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnectedToWiFi = path.usesInterfaceType(.wifi)
            
        }
            
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
}
