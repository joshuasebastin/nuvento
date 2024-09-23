//
//  NetworkManager.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import Network

class NetworkManager {

    static let shared = NetworkManager()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    private var isConnected: Bool = false

    private init() {
        startMonitoring()
    }

    // Function to start monitoring the network
    private func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected = true
            } else {
                self.isConnected = false
            }
        }
        monitor.start(queue: queue)
    }

    // Function to check if network is available
    func isNetworkAvailable() -> Bool {
        return isConnected
    }

    // Optional: Stop monitoring when no longer needed
    func stopMonitoring() {
        monitor.cancel()
    }
}

