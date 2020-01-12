//
//  QuestionCell.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

final class QuestionCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var userDisplayName: UILabel!
    @IBOutlet var creationDateLabel: UILabel!
    @IBOutlet var answerCount: UILabel!
    @IBOutlet var userReputation: UILabel!

    func configCell(with question: Question, for parentView: ParentView) {
        if parentView == .list {
            userDisplayName.isHidden = false
            userReputation.isHidden = false
            userDisplayName.text = question.owner.displayName.decodeHTML().string
            userReputation.text = R.string.localizable.userReputation("\(question.owner.reputation)")
        } else {
            userDisplayName.isHidden = true
            userReputation.isHidden = true
        }

        if question.answerCount > 0 {
            answerCount.backgroundColor = .systemGreen
        } else {
            answerCount.backgroundColor = .systemGray5
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        creationDateLabel.text = formatter.string(for: question.creationDate)
        
        titleLabel.text = question.title.decodeHTML().string
        scoreLabel.text = R.string.localizable.score("\(question.score)")
        answerCount.text = "\(question.answerCount)"
    }
}
