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

    private let spinner = UIActivityIndicatorView(style: .large)

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
    @IBOutlet var questionDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let questionID = questionID {
            dataSource.getQuestion(questionID: questionID)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(showView), name: NSNotification.Name("QuestionDetailsLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(prepareImage), name: NSNotification.Name("ImageLoaded"), object: nil)

        showSpinner()
        mainStackView.isHidden = true

        self.navigationItem.title = R.string.localizable.questionDetails()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.largeTitleDisplayMode = .never
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Actions
    @IBAction func showUserProfile(_ sender: Any) {
        guard let question = self.dataSource.question else {
            preconditionFailure("Unable to initialize view with notexistent question")
        }

        coordinator?.showUserProfile(userID: question.owner.userId)
    }

    @IBAction func shareQuestion(_ sender: UIBarButtonItem) {
        guard let question = self.dataSource.question else {
            return
        }
        let textToShare = question.title.decodeHTML().string
        let link = question.link

        if let url = URL(string: link) {
            let objectsToShare: [Any] = [textToShare, url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.excludedActivityTypes = []

            if UIDevice.current.userInterfaceIdiom == .pad {
                activityVC.popoverPresentationController?.barButtonItem = sender
            }

            self.present(activityVC, animated: true)
        }
    }

    // MARK: - Notification Center Selectors
    @objc
    func showView() {
        guard let question = self.dataSource.question else {
            preconditionFailure("Unable to initialize view with notexistent question")
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = true

        dataSource.getImage(url: question.owner.profileImage)

        questionTitle.text = question.title.decodeHTML().string
        viewCount.text = R.string.localizable.views("\(question.viewCount)")
        answerCount.text = R.string.localizable.answers("\(question.answerCount)")
        userDisplayName.setTitle(question.owner.displayName.decodeHTML().string, for: .normal)
        userRating.text = R.string.localizable.reputation("\(question.owner.reputation)")
        score.text = R.string.localizable.score("\(question.score)")
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        questionDateLabel.text = formatter.string(for: question.creationDate)

        if let questionBody = question.body {
            body.attributedText = questionBody.decodeHTML()
            body.backgroundColor = .systemGray2
            body.isScrollEnabled = false
            body.translatesAutoresizingMaskIntoConstraints = false

            body.delegate = self

            textViewDidChange(body)
        }

        if profileStackView.viewWithTag(1) != nil {
            // required to remove duplicate view adding when back to first question details view
        } else {
            let badgeStack = UIStackView()
            badgeStack.axis = .horizontal
            badgeStack.distribution = .equalSpacing
            badgeStack.spacing = 20
            badgeStack.tag = 1

            profileStackView.addArrangedSubview(badgeStack)

            prepareBadge(color: "bronze", question, badgeStack)
            prepareBadge(color: "silver", question, badgeStack)
            prepareBadge(color: "gold", question, badgeStack)

            createTagLabels(tags: question.tags)
            prepareAnswerViews(question)
        }
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

    @objc
    func showUser(sender: UIButton) {
        coordinator?.showUserProfile(userID: sender.tag)
    }

    // MARK: - View Builder Methods
    func createTagLabels(tags: [String]) {
        tagStackView.translatesAutoresizingMaskIntoConstraints = false

        for (index, tag) in tags.enumerated() {
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
                label.setTitleColor(UIColor.black, for: .normal)
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
            for (index, answer) in answers.enumerated() {
                guard let answerBody = answer.body else {
                    preconditionFailure("Answer body is empty")
                }
                let answerHeader = UIStackView()
                answerHeader.axis = .horizontal
                answerHeader.distribution = .fill
                answerHeader.alignment = .top
                answerHeader.spacing = 20

                mainStackView.addArrangedSubview(answerHeader)

                let answerLabelandDateStack = UIStackView()
                answerLabelandDateStack.axis = .vertical
                answerLabelandDateStack.alignment = .leading
                answerLabelandDateStack.distribution = .fill
                answerLabelandDateStack.spacing = 0

                answerHeader.addArrangedSubview(answerLabelandDateStack)

                let answerLabel = UILabel()
                answerLabel.text = R.string.localizable.answer("\(index+1)")

                let answerDateLabel = UILabel()
                answerDateLabel.font = UIFont.preferredFont(forTextStyle: .caption1)

                let formatter = RelativeDateTimeFormatter()
                formatter.dateTimeStyle = .named
                answerDateLabel.text = formatter.string(for: answer.creationDate)

                answerLabelandDateStack.addArrangedSubview(answerLabel)
                answerLabelandDateStack.addArrangedSubview(answerDateLabel)

                let answerOwnerButton = UIButton()
                answerOwnerButton.setTitle(answer.owner.displayName, for: .normal)

                // pass userId via tag to action method
                answerOwnerButton.tag = answer.owner.userId
                answerOwnerButton.addTarget(self, action: #selector(showUser), for: .touchUpInside)
                answerOwnerButton.setTitleColor(.systemBlue, for: .normal)
                answerOwnerButton.contentHorizontalAlignment = .trailing

                answerHeader.addArrangedSubview(answerOwnerButton)

                let answerTextView = UITextView()

                answerTextView.attributedText = answerBody.decodeHTML()
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
