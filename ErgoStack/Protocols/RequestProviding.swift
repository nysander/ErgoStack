//
//  RequestProviding.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

protocol RequestProviding {
  var urlRequest: URLRequest { get }
}

extension RequestProviding {
    func prepareURL(endpoint: String) -> URL {
        let urlString = "\(APIConfig.domain)/\(APIConfig.version)\(endpoint)&pagesize=\(APIConfig.limit)&order=desc&sort=creation&site=stackoverflow&client_secret=\(APIConfig.clientSecret)&key=\(APIConfig.key)"
        guard let url = URL(string: urlString) else {
            preconditionFailure("Invalid URL used to create URL instance")
        }

        return url
    }

    func prepareURLRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
