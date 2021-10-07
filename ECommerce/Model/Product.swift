//
//  Product.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 8/10/21.
//

import Foundation

struct Product: Codable {
    var name: String?
    var price: Int?
    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case name
        case price
        case imageUrl
    }
}
