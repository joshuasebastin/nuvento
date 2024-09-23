//
//  AddDeviceDetailsModel.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation

enum WeatherAPI {
    case ipAddress
    case ipAddressInfo(String)
    
    var url: URL {
        switch self {
        case .ipAddress:
            return Constants.Urls().getIpAddress()
        case .ipAddressInfo(let info):
            return  Constants.Urls().getIpAddressInfo(ipAddress: info)
        }
    }
}

class AddWeatherViewModel {
    
    // Generic function to load data for different models
    func loadWeatherData<T: Decodable>(for api: WeatherAPI, modelType: T.Type, completion: @escaping (T?) -> Void) {
        
        let weatherURL = api.url
        
        let weatherResource = Resource<T>(url: weatherURL) { data in
            return try? JSONDecoder().decode(T.self, from: data)
        }
        
        Webservice().load(resource: weatherResource) { result in
            if let weatherData = result {
                completion(weatherData)
            } else {
                completion(nil)
            }
        }
    }
}
