//
//  SOEndpoint.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

enum SOEndpoint {
    case getQuestions
    case getQuestion(questionID: Int)
    case getUser(userID: Int)
    case getImage(url: String)
}

extension SOEndpoint: RequestProviding {
    var urlRequest: URLRequest {
        switch self {
        case .getQuestions:
            let url = prepareURL(endpoint: "/questions")
            let request = prepareURLRequest(for: url)
            return request

        case let .getQuestion(questionID):
            let url = prepareURL(endpoint: "/questions/\(questionID)")
            let request = prepareURLRequest(for: url)
            return request

        case let .getUser(userID):
            let url = prepareURL(endpoint: "/users/\(userID)")
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
