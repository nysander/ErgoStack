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

    func configCell(with question: Question, for parentView: ParentView) {
        if parentView == .list {
            userDisplayName.isHidden = false
            userReputation.isHidden = false
            userDisplayName.text = decodeHTML(string: question.owner.displayName, fontStyle: .caption).string
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
        
        titleLabel.text = decodeHTML(string: question.title, fontStyle: .headline).string
        scoreLabel.text = "Score: \(question.score)"
        answerCount.text = "\(question.answerCount)"
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
