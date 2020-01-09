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
    @IBOutlet var userPhoto: UIImageView!
    @IBOutlet var userRating: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var answerCount: UILabel!
    @IBOutlet var viewCount: UILabel!
    @IBOutlet var body: UITextView!
    @IBOutlet var tagStackView: UIStackView!
    @IBOutlet var profileStackView: UIStackView!
    @IBOutlet var userDisplayName: UIButton!


    let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let questionID = questionID else {
            preconditionFailure("Unable to initialise View Controller without Question ID")
        }
        dataSource.getQuestion(questionID: questionID)

        NotificationCenter.default.addObserver(self, selector: #selector(showView), name: NSNotification.Name("QuestionDetailsLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(prepareImage), name: NSNotification.Name("ImageLoaded"), object: nil)

        showSpinner()
        mainStackView.isHidden = true
    }

    @IBAction func showUserProfile(_ sender: Any) {
        guard let question = self.dataSource.question else {
            preconditionFailure("Unable to initialize view with notexistent question")
        }

        coordinator?.showUserProfile(userID: question.owner.userId)
    }


    // MARK: - Notification Center Selectors
    @objc
    func showView() {
        guard let question = self.dataSource.question else {
            preconditionFailure("Unable to initialize view with notexistent question")
        }

        dataSource.getImage(url: question.owner.profileImage)
        createTagLabels(tags: question.tags)
        prepareAnswerViews(question)

        questionTitle.text = decodeHTML(string: question.title, fontStyle: .title).string
        viewCount.text = "Views: \(question.viewCount)"
        answerCount.text = "Answers: \(question.answerCount)"
        userDisplayName.setTitle(decodeHTML(string: question.owner.displayName).string, for: .normal)
        userRating.text = "\(question.owner.reputation)"
        score.text = "Score: \(question.score)"

        if let questionBody = question.body {
            body.attributedText = decodeHTML(string: questionBody)
            body.backgroundColor = .systemGray2
            body.isScrollEnabled = false
            body.translatesAutoresizingMaskIntoConstraints = false

            body.delegate = self

            textViewDidChange(body)
        }

        let badgeStack = UIStackView()
        badgeStack.axis = .horizontal
        badgeStack.distribution = .equalSpacing
        badgeStack.spacing = 20

        profileStackView.addArrangedSubview(badgeStack)

        prepareBadge(color: "bronze", question, badgeStack)
        prepareBadge(color: "silver", question, badgeStack)
        prepareBadge(color: "gold", question, badgeStack)

        spinner.removeFromSuperview()
        mainStackView.isHidden = false
    }

    @objc
    func prepareImage() {
        guard !dataSource.imageData.isEmpty else {
            preconditionFailure("No image data")
        }
        userPhoto.image = UIImage(data: dataSource.imageData)
        userPhoto.contentMode = .scaleToFill
        userPhoto.layer.cornerRadius = view.frame.size.width / 32
        userPhoto.clipsToBounds = true
    }

    // MARK: - View Builder Methods
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
            label.layer.cornerRadius = view.frame.size.width / 128

            tagStackView.addArrangedSubview(label)

            if index == 3 {
                break
            }
        }
    }

    func prepareBadge(color: String, _ question: Question, _ badgeStack: UIStackView) {
        if let badges = question.owner.badgeCounts, let count = badges[color], count > 0 {
            print("in")
            let label = UIButton()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setTitle("\(count)", for: .normal)
            label.titleLabel?.numberOfLines = 0
            label.titleLabel?.adjustsFontForContentSizeCategory = true
            label.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
            label.titleLabel?.textColor = .white
            label.isUserInteractionEnabled = false
            label.layer.cornerRadius = view.frame.size.width / 128
            switch color {
            case "bronze":
                label.backgroundColor = .brown
            case "silver":
                label.backgroundColor = .gray
            case "gold":
                label.backgroundColor = .yellow
                label.titleLabel?.textColor = .black
            default:
                label.backgroundColor = .white
            }

            label.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            label.isUserInteractionEnabled = false

            badgeStack.addArrangedSubview(label)
        }
    }


    func prepareAnswerViews(_ question: Question) {
        if let answers = question.answers {
            for answer in answers {
                guard let answerBody = answer.body else {
                    preconditionFailure("Answer body is empty")
                }
                let answerTextView = UITextView()

                answerTextView.attributedText = decodeHTML(string: answerBody)
                answerTextView.backgroundColor = .systemGray4
                answerTextView.isScrollEnabled = false
                answerTextView.translatesAutoresizingMaskIntoConstraints = false

                answerTextView.delegate = self

                mainStackView.addArrangedSubview(answerTextView)
                textViewDidChange(answerTextView)
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

extension QuestionDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: mainStackView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
