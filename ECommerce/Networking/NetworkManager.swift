//
//  NetworkManager.swift
//  ECommerce
//
//  Created by Tashreque Mohammed Haq on 7/10/21.
//

import Foundation

protocol NetworkManagerDelegate {
    /**
     This function is used to perform a GET request based on the specified endpoint.

     - parameter endpoint: The enpoint for which the request should be made.
     - parameter completion: The completion block which is called after a response gets returned. A result instance is the parameter for this closure.
     */
    func getRequest<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> ())

    /**
     This function is used to download image data based on the specified url.

     - parameter urlString: The url string to which the request should be made.
     - parameter completion: The completion block which is called after a response gets returned. A result instance is the parameter for this closure.
     - parameter currentDownloadTask: A closure to keep track of the currrent download task being used.
     */
    func getImage(fromUrlString urlString: String, completion: @escaping (Result<Data, NetworkError>) -> (), currentDownloadTask: (URLSessionDownloadTask?) -> ())

    /**
     This function is used to perform an upload request based on the specified endpoint.

     - parameter requestBody: The body for the request to be made.
     - parameter endpoint: The enpoint for which the request should be made.
     - parameter completion: The completion block which is called after a response gets returned. An optional `NetworkError` instance is the parameter for this closure.
     */
    func uploadRequest<T: Codable>(requestBody: T, endpoint: Endpoint, completion: @escaping (NetworkError?) -> ())
}

class NetworkManager: NetworkManagerDelegate {

    // The single one time only instance of this class.
    static let shared = NetworkManager()

    // The initializer made private so that this class cannot be instantiated.
    private init() {}

    // The singleton instance of URLSession.
    private let session = URLSession.shared

    func getRequest<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> ()) {
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
                completion(.failure(.failedRequest))
                print(error?.localizedDescription ?? "Unknown error!")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Wrong response type!")
                completion(.failure(.badResponse))
                return
            }

            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                print("Error status code: \(httpResponse.statusCode)")
                completion(.failure(.badStatusCode(code: statusCode)))
                return
            }

            guard let data = data else {
                print("Bad data!")
                completion(.failure(.badData))
                return
            }

            do {
                let responseObject = try JSONDecoder().decode(T.self, from: data)
                print("Successfully parsed response object!")
                completion(.success(responseObject))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.failedDataParsing))
            }
        }
        dataTask.resume()
    }

    func getImage(fromUrlString urlString: String, completion: @escaping (Result<Data, NetworkError>) -> (), currentDownloadTask: (URLSessionDownloadTask?) -> ()) {
        var downloadTask: URLSessionDownloadTask?
        guard let url = URL(string: urlString) else {
            return
        }

        // Create a download task, start it and handle corresponding errors.
        downloadTask = session.downloadTask(with: url) { tempUrl, response, error in
            guard error == nil else {
                completion(.failure(.failedRequest))
                print(error?.localizedDescription ?? "Unknown error!")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Wrong response type!")
                completion(.failure(.badResponse))
                return
            }

            let statusCode = httpResponse.statusCode
            guard (200...299).contains(statusCode) else {
                print("Error status code: \(httpResponse.statusCode)")
                completion(.failure(.badStatusCode(code: statusCode)))
                return
            }

            do {
                let data = try Data(contentsOf: url)
                print("Successfully retrieved data from url!")
                completion(.success(data))
            } catch {
                print(error.localizedDescription)
                completion(.failure(.failedDataParsing))
            }
        }
        currentDownloadTask(downloadTask)
        downloadTask?.resume()
    }

    func uploadRequest<T: Codable>(requestBody: T, endpoint: Endpoint, completion: @escaping (NetworkError?) -> ()) {
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
                    completion(.failedRequest)
                    print(error?.localizedDescription ?? "Unknown error!")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Wrong response type!")
                    completion(.badResponse)
                    return
                }

                let statusCode = httpResponse.statusCode
                guard (200...299).contains(statusCode) else {
                    print("Error status code: \(httpResponse.statusCode)")
                    completion(.badStatusCode(code: statusCode))
                    return
                }

                guard responseData != nil else {
                    print("Bad data!")
                    completion(.badData)
                    return
                }
                completion(nil)
            }
            uploadTask.resume()
        } catch {
            print("Error during encoding: \(error.localizedDescription)")
            completion(.failedDataParsing)
        }
    }
}
