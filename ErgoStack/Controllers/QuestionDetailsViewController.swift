//
//  QuestionDetailsViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

class QuestionDetailsViewController: UIViewController {
    var questionID: Int?
    weak var coordinator: MainCoordinator?
    
    var dataSource = AppDelegate.dataSource

    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var questionTitle: UILabel!
    @IBOutlet var userDisplayName: UILabel!
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var userRating: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var answerCount: UILabel!
    @IBOutlet var viewCount: UILabel!
    @IBOutlet var body: UITextView!
    @IBOutlet var tagStackView: UIStackView!

    let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let questionID = questionID else {
            preconditionFailure("Unable to initialise View Controller without Question ID")
        }

        NotificationCenter.default.addObserver(self, selector: #selector(showView), name: NSNotification.Name("QuestionDetailsLoaded"), object: nil)

        dataSource.getQuestion(questionID: questionID)

        showSpinner()
        mainStackView.isHidden = true
    }

    @objc
    func showView() {
        guard let question = self.dataSource.question else {
            preconditionFailure("Unable to initialize view with notexistent question")
        }
        questionTitle.attributedText = decodeHTML(string: question.title, fontStyle: .headline)
        viewCount.text = "Views: \(question.viewCount)"
        answerCount.text = "Answers: \(question.answerCount)"
        userDisplayName.attributedText = decodeHTML(string: question.owner.displayName, fontStyle: .caption)
        userRating.text = "\(question.owner.reputation)"
        score.text = "Question score: \(question.score)"

        createTagLabels(tags: question.tags)
        if let questionBody = question.body {
            body.attributedText = decodeHTML(string: questionBody)
            body.backgroundColor = .systemGray2
        }

        spinner.removeFromSuperview()
        mainStackView.isHidden = false
    }

    func createTagLabels(tags: [String]) {
        tagStackView.translatesAutoresizingMaskIntoConstraints = false

        for (index,tag) in tags.enumerated() {
            let label = UIButton()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setTitle(tag, for: .normal)
            label.titleLabel?.numberOfLines = 0
            label.titleLabel?.adjustsFontForContentSizeCategory = true
            label.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
            label.backgroundColor = .systemBlue
            label.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            label.isUserInteractionEnabled = false

            tagStackView.addArrangedSubview(label)

            if index == 3 {
                break
            }
        }
    }

    func showSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func decodeHTML(string: String, fontStyle: FontType = .body) -> NSAttributedString {
        let modifiedFont = NSString(format:"<span style=\"font: -apple-system\(fontStyle.suffix); font-size: \(UIFont.systemFontSize)\">%@</span>" as NSString, string)

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
