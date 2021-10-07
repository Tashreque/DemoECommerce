//
//  StoreInfo.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 8/10/21.
//

import Foundation

struct StoreInfo: Codable {
    var name: String?
    var rating: Double?
    var openingTime: String?
    var closingTime: String?

    enum CodingKeys: String, CodingKey {
        case name
        case rating
        case openingTime
        case closingTime
    }
}
