//
//  Answer.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//


/*
 "answers": [
   {
     "owner": {
       "reputation": 3382,
       "user_id": 1001057,
       "user_type": "registered",
       "accept_rate": 92,
       "profile_image": "https://i.stack.imgur.com/RhIBt.jpg?s=128&g=1",
       "display_name": "imike",
       "link": "https://stackoverflow.com/users/1001057/imike"
     },
     "is_accepted": true,
     "score": 3,
     "last_activity_date": 1575236864,
     "last_edit_date": 1575236864,
     "creation_date": 1575233995,
     "answer_id": 59129923,
     "question_id": 59129540,
     "body": " HTML BODY "
   }
 ],
 */
import Foundation

struct Answer: Decodable {
    let answerId: Int
    let questionId: Int
    let creationDate: Date
    let body: String
    let isAccepted: Bool
    let score: Int
    let lastActivityDate: Date
    let lastEditDate: Date
    let owner: User
}
