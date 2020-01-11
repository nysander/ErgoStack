//
//  LocalStore.swift
//  ErgoStack
//
//  Created by Pawel Madej on 11/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

protocol LocalStore {
    func execute<T: Decodable>(from fileName: String, completion: @escaping (Result<T, Error>) -> Void)
}

extension LocalStore {
    func execute<T: Decodable>(from fileName: String, completion: @escaping (Result<T, Error>) -> Void) {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let decodedObject = try decoder.decode(T.self, from: data)
                return completion(.success(decodedObject))
            } catch {
                return completion(.failure(error))
            }
        }
    }
}
