//
//  NetworkError.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import Foundation

enum NetworkError: Error {
    case badStatusCode(code: Int)
    case badData
    case badResponse
    case failedDataParsing
}
