//
//  Constants.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation
import UIKit

struct Constants {
    struct Urls {
        func getIpAddress() -> URL{
            return URL(string: "https://api.ipify.org?format=json")!
        }
        func getIpAddressInfo(ipAddress:String) -> URL{
            return URL(string: "https://ipinfo.io/\(ipAddress)/geo")!
        }
    }
}
