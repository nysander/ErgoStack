//
//  User.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

/*
 {
   "items": [
     {
       "badge_counts": {
         "bronze": 33,
         "silver": 14,
         "gold": 0
       },
       "account_id": 1345039,
       "is_employee": false,
       "last_modified_date": 1573682649,
       "last_access_date": 1578412941,
       "reputation_change_year": 0,
       "reputation_change_quarter": 0,
       "reputation_change_month": 0,
       "reputation_change_week": 0,
       "reputation_change_day": 0,
       "reputation": 701,
       "creation_date": 1332421095,
       "user_type": "registered",
       "user_id": 1285959,
       "accept_rate": 75,
       "location": "Polska",
       "website_url": "https://www.pawelmadej.com",
       "link": "https://stackoverflow.com/users/1285959/pawe%c5%82-madej",
       "profile_image": "https://i.stack.imgur.com/vWIwN.jpg?s=128&g=1",
       "display_name": "Paweł Madej"
     }
   ],
   "has_more": false,
   "quota_max": 10000,
   "quota_remaining": 9930
 }

 Fields from question:
 "reputation": 11,
 "user_id": 12662447,
 "user_type": "registered",
 "profile_image": "https://www.gravatar.com/avatar/3a038d23db6ada803040cad3f8067901?s=128&d=identicon&r=PG&f=1",
 "display_name": "ginopono",
 "link": "https://stackoverflow.com/users/12662447/ginopono"

 */
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

/*
"items": [
  {
    "badge_counts": {
      "bronze": 33,
      "silver": 14,
      "gold": 0
    },
    "answer_count": 14,
    "question_count": 34,
    "account_id": 1345039,
    "is_employee": false,
    "last_modified_date": 1573682649,
    "last_access_date": 1578501265,
    "reputation_change_year": 0,
    "reputation_change_quarter": 0,
    "reputation_change_month": 0,
    "reputation_change_week": 0,
    "reputation_change_day": 0,
    "reputation": 701,
    "creation_date": 1332421095,
    "user_type": "registered",
    "user_id": 1285959,
    "accept_rate": 75,
    "about_me": "",
    "location": "Polska",
    "website_url": "https://www.pawelmadej.com",
    "link": "https://stackoverflow.com/users/1285959/pawe%c5%82-madej",
    "profile_image": "https://i.stack.imgur.com/vWIwN.jpg?s=128&g=1",
    "display_name": "Paweł Madej"
  }
],
 */
