//
//  Answer.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

struct Answer: Decodable {
    let answerId: Int
    let questionId: Int
    let creationDate: Date
    let body: String?
    let isAccepted: Bool
    let score: Int
    let lastActivityDate: Date
    let lastEditDate: Date?
    let owner: User
}
