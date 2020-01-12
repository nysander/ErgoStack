//
//  Question.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let questionId: Int
    let title: String
    let owner: User
    let tags: [String]
    let isAnswered: Bool
    let viewCount: Int
    let answerCount: Int
    let score: Int
    let lastActivityDate: Date?
    let creationDate: Date
    let lastEditDate: Date?
    let link: String
    let body: String?
    var answers: [Answer]?
}

struct QuestionListResponse: Decodable {
    let items: [Question]
}
