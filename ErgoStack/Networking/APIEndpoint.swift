//
//  APIEndpoint.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

enum APIEndpoint {
    case getQuestions
    case getQuestion(questionID: Int)
    case getUser(userID: Int)
    case getUserQuestions(userID: Int)

    case search(query: String)

    case getImage(url: String)
}

extension APIEndpoint: RequestProviding {
    var urlRequest: URLRequest {
        switch self {
        case .getQuestions:
            let url = prepareURL(endpoint: "/questions?filter=")
            let request = prepareURLRequest(for: url)
            return request

        case let .getQuestion(questionID):
            let url = prepareURL(endpoint: "/questions/\(questionID)?filter=!b1MMEAHGb2X2p*")
            let request = prepareURLRequest(for: url)
            return request

        case let .getUser(userID):
            let url = prepareURL(endpoint: "/users/\(userID)?filter=!-*jbN*CqbrZu")
            let request = prepareURLRequest(for: url)
            return request

        case let .getUserQuestions(userID):
            let url = prepareURL(endpoint: "/users/\(userID)/questions?filter=")
            let request = prepareURLRequest(for: url)
            return request

        case let .search(query):
            guard let queryEncoded = query.stringByAddingPercentEncodingForRFC3986() else {
                preconditionFailure("unable to create encoded string")
            }
            let url = prepareURL(endpoint: "/search/advanced?q=\(queryEncoded)&filter=")
            let request = prepareURLRequest(for: url)
            return request

        case let .getImage(url):
            guard let url = URL(string: url) else {
                preconditionFailure("Invalid Image URL provided")
            }
            let request = prepareURLRequest(for: url)
            return request
        }
    }
}
