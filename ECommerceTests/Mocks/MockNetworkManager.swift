//
//  MockNetworkManager.swift
//  ECommerceTests
//
//  Created by Tashreque Mohammed Haq on 11/10/21.
//

import Foundation
@testable import ECommerce

class MockNetworkManager: NetworkManagerDelegate {

    // The single one time only instance of this class.
    static let shared = MockNetworkManager()

    // The initializer made private so that this class cannot be instantiated.
    private init() {}

    // The singleton instance of URLSession.
    private let session = URLSession.shared

    func getRequest<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> ()) {
        var fileName = ""
        if endpoint.path.contains("/storeInfo") {
            fileName = "storeInfo"
        }
        if endpoint.path.contains("/products") {
            fileName = "products"
        }

        if let fileLocation = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileLocation)
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 2) {
                    completion(.success(parsedData))
                }
            } catch {
                completion(.failure(.failedDataParsing))
            }
        }
    }

    func getImage(fromUrlString urlString: String, completion: @escaping (Result<Data, NetworkError>) -> (), currentDownloadTask: (URLSessionDownloadTask?) -> ()) {
        if let fileLocation = Bundle(for: type(of: self)).url(forResource: "itemImage", withExtension: "png") {
            do {
                let data = try Data(contentsOf: fileLocation)
                DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 2) {
                    completion(.success(data))
                }
            } catch {
                completion(.failure(.failedDataParsing))
            }
            currentDownloadTask(nil)
        }
    }

    func uploadRequest<T: Codable>(requestBody: T, endpoint: Endpoint, completion: @escaping (NetworkError?) -> ()) {
        do {
            let _ = try JSONEncoder().encode(requestBody.self)
            DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 2) {
                completion(nil)
            }
        } catch {
            completion(.failedDataParsing)
        }
    }
}

