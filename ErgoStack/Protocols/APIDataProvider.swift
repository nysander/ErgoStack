//
//  APIDataProvider.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

protocol APIDataProvider {
    var network: Networking { get }

    func getQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getQuestion(questionID: Int, _ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getUser(userID: Int, _ completion: @escaping (Result<UserListResponse, Error>) -> Void)
    func getUserQuestions(userID: Int, _ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getImage(url: String, _ completion: @escaping (Result<Data, Error>) -> Void)
    func search(query: String, _ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
}

extension APIDataProvider {
    func getQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        network.execute(APIEndpoint.getQuestions, completion: completion)
    }

    func getQuestion(questionID: Int, _ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        network.execute(APIEndpoint.getQuestion(questionID: questionID), completion: completion)
    }

    func getUser(userID: Int, _ completion: @escaping (Result<UserListResponse, Error>) -> Void) {
        network.execute(APIEndpoint.getUser(userID: userID), completion: completion)
    }

    func getUserQuestions(userID: Int, _ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        network.execute(APIEndpoint.getUserQuestions(userID: userID), completion: completion)
    }

    func getImage(url: String, _ completion: @escaping (Result<Data, Error>) -> Void) {
        network.execute(APIEndpoint.getImage(url: url), completion: completion)
    }

    func search(query: String, _ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        network.execute(APIEndpoint.search(query: query), completion: completion)
    }
}
