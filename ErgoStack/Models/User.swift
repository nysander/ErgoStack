//
//  User.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Foundation

struct User: Decodable {
    // summary fields
    let userId: Int
    let displayName: String
    let link: String
    let profileImage: String
    let reputation: Int
    let userType: String

    // full profile fields
    let accountId: Int?
    let acceptRate: Int?
    let creationDate: Date?
    let isEmployee: Bool?
    let lastModifiedDate: Date?
    let lastAccessDate: Date?
    let location: String?
    let reputationChangeYear: Int?
    let reputationChangeQuarter: Int?
    let reputationChangeMonth: Int?
    let reputationChangeDay: Int?
    let websiteUrl: String?
    let badgeCounts: [String: Int]?
    let questionCount: Int?
    let answerCount: Int?
    let aboutMe: String?
}

struct UserListResponse: Decodable {
    let items: [User]
}
