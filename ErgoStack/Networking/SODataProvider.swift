//
//  SODataProvider.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

class SOService: SODataProvider {
    var network: Networking

    init() {
        self.network = DefaultNetworkingAgent()
    }
}

protocol SODataProvider {
    var network: Networking { get }

    func getQuestions(_ completion: @escaping (Result<[Question], Error>) -> Void)
    func getQuestion(questionID: Int, _ completion: @escaping (Result<Question, Error>) -> Void)
    func getUser(userID: Int, _ completion: @escaping (Result<User, Error>) -> Void)
    func getImage(url: String, _ completion: @escaping (Result<Data, Error>) -> Void)
}

extension SODataProvider {
    func getQuestions(_ completion: @escaping (Result<[Question], Error>) -> Void) {
        network.execute(SOEndpoint.getQuestions, completion: completion)
    }

    func getQuestion(questionID: Int,_ completion: @escaping (Result<Question, Error>) -> Void) {
        network.execute(SOEndpoint.getQuestion(questionID: questionID), completion: completion)
    }

    func getUser(userID: Int, _ completion: @escaping (Result<User, Error>) -> Void) {
        network.execute(SOEndpoint.getUser(userID: userID), completion: completion)
    }

    func getImage(url: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        network.execute(SOEndpoint.getImage(url: url), completion: completion)
    }
}
