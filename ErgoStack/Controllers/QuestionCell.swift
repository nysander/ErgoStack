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

    func configCell(with question: Question) {
        titleLabel.text = question.title
        scoreLabel.text = "\(question.score)"
        userDisplayName.text = question.owner.displayName
        answerCount.text = "\(question.answerCount)"
        userReputation.text = "\(question.owner.reputation)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        creationDateLabel.text = formatter.string(from: question.creationDate)
    }
}
