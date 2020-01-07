//
//  Networking.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class DefaultNetworkingAgent: Networking {
    var sessionConfig: URLSessionConfiguration
    var session: URLSession

    init() {
        self.sessionConfig = URLSessionConfiguration.default
        self.sessionConfig.waitsForConnectivity = true
        self.sessionConfig.timeoutIntervalForResource = 60 * 60 // 1 hour

        self.session = URLSession(configuration: self.sessionConfig)
    }
}

protocol Networking {
    var sessionConfig: URLSessionConfiguration { get set }
    var session: URLSession { get set }

    func execute<T: Decodable>(_ requestProvider: RequestProviding, completion: @escaping (Result<T, Error>) -> Void)
//    func execute(_ requestProvider: RequestProviding, completion: @escaping (Result<HTTPURLResponse, Error>) -> Void)
}

extension Networking {
    func execute<T: Decodable>(_ requestProvider: RequestProviding, completion: @escaping (Result<T, Error>) -> Void) {
        let urlRequest = requestProvider.urlRequest

        session.dataTask(with: urlRequest) { data, _, error in
            do {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    preconditionFailure("No error was received but we also don't have data...")
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let decodedObject = try decoder.decode(T.self, from: data)

                completion(.success(decodedObject))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

//    func execute(_ requestProvider: RequestProviding, completion: @escaping (Result<HTTPURLResponse, Error>) -> Void) {
//        let urlRequest = requestProvider.urlRequest
//
//        session.dataTask(with: urlRequest) { _, response, error in
//            do {
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                guard let response = response as? HTTPURLResponse else {
//                    preconditionFailure("Invalid HTTPURLResponse")
//                }
//
//                switch response.statusCode {
//                case 200, 201, 204:
//                    completion(.success(response))
//                default:
//                    throw NetworkingError.invalidResponseStatusCode(statusCode: response.statusCode)
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
}