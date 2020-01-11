//
//  LocalDataProvider.swift
//  ErgoStack
//
//  Created by Pawel Madej on 11/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

protocol LocalDataProvider {
    var localStore: LocalStore { get }

    func getQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getQuestion(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
    func getUser(_ completion: @escaping (Result<UserListResponse, Error>) -> Void)
    func getUserQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void)
}

extension LocalDataProvider {
    func getQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        localStore.execute(from: "questions", completion: completion)
    }

    func getQuestion(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        localStore.execute(from: "questionDetails", completion: completion)
    }

    func getUser(_ completion: @escaping (Result<UserListResponse, Error>) -> Void) {
        localStore.execute(from: "userProfile", completion: completion)
    }

    func getUserQuestions(_ completion: @escaping (Result<QuestionListResponse, Error>) -> Void) {
        localStore.execute(from: "userQuestions", completion: completion)
    }
}
