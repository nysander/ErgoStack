//
//  QuestionCell.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

enum FontType {
    case headline
    case body
    case caption
    case title

    var suffix: String {
        switch self {
        case .headline:
            return "-headline"
        case .caption:
            return "-caption1"
        case .title:
            return "-title1"
        default:
            return "-body"
        }
    }
}

import UIKit

final class QuestionCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var userDisplayName: UILabel!
    @IBOutlet var creationDateLabel: UILabel!
    @IBOutlet var answerCount: UILabel!
    @IBOutlet var userReputation: UILabel!

    func configCell(with question: Question) {
        titleLabel.attributedText = decodeHTML(string: question.title, fontStyle: .headline)

        scoreLabel.text = "Score: \(question.score)"
        userDisplayName.attributedText = decodeHTML(string: question.owner.displayName, fontStyle: .caption)
        answerCount.text = "\(question.answerCount)"
        if question.answerCount > 0 {
            answerCount.backgroundColor = .systemGreen
        } else {
            answerCount.backgroundColor = .systemGray5
        }
        userReputation.text = "User reputation: \(question.owner.reputation)"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        creationDateLabel.text = formatter.string(from: question.creationDate)
    }

    func decodeHTML(string: String, fontStyle: FontType = .body) -> NSAttributedString {
        let modifiedFont = NSString(format: "<span style=\"font: -apple-system\(fontStyle.suffix); font-size: \(UIFont.systemFontSize)\">%@</span>" as NSString, string)

        guard let data = modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true) else {
            return NSAttributedString(string: "")
        }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]

        do {
            let attributedString = try NSAttributedString(data: data,
                                                          options: options,
                                                          documentAttributes: nil)
            return attributedString
        } catch {
            return NSAttributedString(string: "")
        }
    }
}
