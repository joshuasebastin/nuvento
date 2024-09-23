//
//  IPAddressInfoModel.swift
//  nuvento
//
//  Created by Joshua on 21/09/24.
//

import Foundation


// MARK: - IPAddressInfoModel
struct IPAddressInfoModel: Codable {
    let ip, city, region, country: String
    let loc, org, postal, timezone: String
    let readme: String
}
