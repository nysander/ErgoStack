//
//  Question.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

/* Example Question object
 {
   "items": [
     {
       "tags": [
         "r",
         "date",
         "lubridate"
       ],
       "owner": {
         "reputation": 11,
         "user_id": 12662447,
         "user_type": "registered",
         "profile_image": "https://www.gravatar.com/avatar/3a038d23db6ada803040cad3f8067901?s=128&d=identicon&r=PG&f=1",
         "display_name": "ginopono",
         "link": "https://stackoverflow.com/users/12662447/ginopono"
       },
       "is_answered": true,
       "view_count": 34,
       "answer_count": 5,
       "score": 1,
       "last_activity_date": 1578412550,
       "creation_date": 1578407572,
       "last_edit_date": 1578410487,
       "question_id": 59630491,
       "link": "https://stackoverflow.com/questions/59630491/r-converting-consecutive-dates-from-a-single-column-into-a-2-column-range",
       "title": "R: Converting consecutive dates from a single column into a 2-column range"
     }
   ],
   "has_more": true,
   "quota_max": 10000,
   "quota_remaining": 9946
 }
 */

import Foundation

struct Question {
    let questionId: Int
    let title: String
    let owner: User
    let tags: [String]
    let isAnswered: Bool
    let viewCount: Int
    let answerCount: Int
    let score: Int
    let lastActivityDate: Date
    let creationDate: Date
    let lastEditDate: Date
    let link: String
    let body: String
    let answers: [Answer]
}
