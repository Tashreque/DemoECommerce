//
//  StoreEndpoint.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import Foundation

/// The endpoint enumeration which contains all the store related rest endpoint information in order to make an HTTP request.
enum StoreEndpoint: Endpoint {
    // The API endpoint cases for the store.
    case storeInfo
    case products
    case order

    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }

    var baseUrl: String {
        switch self {
        default:
            return "virtserver.swaggerhub.com"
        }
    }

    var path: String {
        switch self {
        case .storeInfo:
            return "/m-tul/opn-mobile-challenge-api/1.0.0/storeInfo"
        case .products:
            return "/m-tul/opn-mobile-challenge-api/1.0.0/products"
        case .order:
            return "/m-tul/opn-mobile-challenge-api/1.0.0/order"
        }
    }

    var parameters: [URLQueryItem] {
        // Since none of the requests require any query parameters, an empty array is returned for now.
        return []
    }

    var method: String {
        switch self {
        case .storeInfo:
            return "GET"
        case .products:
            return "GET"
        case .order:
            return "POST"
        }
    }
}
