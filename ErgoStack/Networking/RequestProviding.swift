//
//  RequestProviding.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

enum API {
    static let version = "2.2"
    static let domain = "https://api.stackexchange.com/"

    static let questionFilter = ""
}

protocol RequestProviding {
  var urlRequest: URLRequest { get }
}

/* example query
    api.stackexchange.com/2.2/questions/59129540?order=desc&sort=creation&site=stackoverflow&filter=!-*jbN-o8P3E5
 */
extension RequestProviding {
    func prepareURL(endpoint: String) -> URL {
        let urlString = "\(API.domain)/\(API.version)\(endpoint)?order=desc&sort=creation&site=stackoverflow&filter=\(API.questionFilter)"
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
