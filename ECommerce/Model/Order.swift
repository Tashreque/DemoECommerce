//
//  Order.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 8/10/21.
//

import Foundation

struct Order: Codable {
    var products: [Product]?
    var deliveryAddress: String?

    enum CodingKeys: String, CodingKey {
        case products
        case deliveryAddress = "delivery_address"
    }
}
