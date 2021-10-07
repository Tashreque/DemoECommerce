//
//  NetworkManager.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import Foundation

class NetworkManager {

    // The single one time only instance of this class.
    static let shared = NetworkManager()

    // The initializer made private so that this class cannot be instantiated.
    private init() {}

    // The singleton instance of URLSession.
    private let session = URLSession.shared

    func getRequest<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> ()) {
        // Setup a URLComponents object based on the properties of the endpoint.
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.queryItems = endpoint.parameters
        components.host = endpoint.baseUrl
        components.path = endpoint.path

        // Construct URL from the URLComponents instance.
        guard let url = components.url else { return }

        // Create the URL request object.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method

        // Create a data task from the URLSession object. Within the response closure, the response, error and data are handled.
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown error!")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Wrong response type!")
                completion(.failure(NetworkError.badResponse))
                return
            }

            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                print("Error status code: \(httpResponse.statusCode)")
                completion(.failure(NetworkError.badStatusCode(code: statusCode)))
                return
            }

            guard let data = data else {
                print("Bad data!")
                completion(.failure(NetworkError.badData))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                print("Successfully parsed response object!")
                completion(.success(responseObject))
            } catch {
                print(error.localizedDescription)
                completion(.failure(NetworkError.failedDataParsing))
            }
        }
        dataTask.resume()
    }

    func getImage(fromUrlString urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }

        // Create a download task, start it and handle corresponding errors.
        let downloadTask = session.downloadTask(with: url) { tempUrl, response, error in
            guard error == nil else {
                completion(.failure(error!))
                print(error?.localizedDescription ?? "Unknown error!")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Wrong response type!")
                completion(.failure(NetworkError.badResponse))
                return
            }

            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                print("Error status code: \(httpResponse.statusCode)")
                completion(.failure(NetworkError.badStatusCode(code: statusCode)))
                return
            }

            do {
                let data = try Data(contentsOf: url)
                print("Successfully retrieved data from url!")
                completion(.success(data))
            } catch {
                print(error.localizedDescription)
                completion(.failure(NetworkError.failedDataParsing))
            }
        }
        downloadTask.resume()
    }

    func uploadRequest<T: Codable>(requestBody: T, endpoint: Endpoint, completion: @escaping (Result<Bool, Error>) -> ()) {
        // Setup a URLComponents object based on the properties of the endpoint.
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.queryItems = endpoint.parameters
        components.host = endpoint.baseUrl
        components.path = endpoint.path

        // Construct URL from the URLComponents instance.
        guard let url = components.url else { return }

        // Create the URL request object.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method

        do {
            let data = try JSONEncoder().encode(requestBody.self)
            print("Successfully encoded data!")

            // Create an upload task, handle corresponding errors.
            let uploadTask = session.uploadTask(with: urlRequest, from: data) { responseData, response, error in
                guard error == nil else {
                    completion(.failure(error!))
                    print(error?.localizedDescription ?? "Unknown error!")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Wrong response type!")
                    completion(.failure(NetworkError.badResponse))
                    return
                }

                let statusCode = httpResponse.statusCode
                guard (200...299).contains(statusCode) else {
                    print("Error status code: \(httpResponse.statusCode)")
                    completion(.failure(NetworkError.badStatusCode(code: statusCode)))
                    return
                }

                guard responseData != nil else {
                    print("Bad data!")
                    completion(.failure(NetworkError.badData))
                    return
                }

                // Request successful!
                completion(.success(true))
            }
            uploadTask.resume()
        } catch {
            print("Error during encoding: \(error.localizedDescription)")
            completion(.failure(NetworkError.failedDataParsing))
        }
    }
}
