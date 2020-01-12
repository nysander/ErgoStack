//
//  UserProfileViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, QuestionListProviding {
    var userID: Int?
    let dataSource = AppDelegate.dataSource
    weak var coordinator: MainCoordinator?

    private let spinner = UIActivityIndicatorView(style: .large)

    private var image = UIImage()
    private var topMessage = R.string.localizable.loading()
    private var bottomMessage = R.string.localizable.pleaseWait()

    @IBOutlet var dataProvider: QuestionTableViewDataProvider!
    @IBOutlet var displayName: UILabel!
    @IBOutlet var creationDateLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var questionCountLabel: UILabel!
    @IBOutlet var answerCountLabel: UILabel!
    @IBOutlet var aboutMeTextView: UITextView!
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var badgesStackView: UIStackView!
    @IBOutlet var labelStackView: UIStackView!
    @IBOutlet var questionStackView: UIStackView!

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        registerNotificationObservers()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.rowHeight = UITableView.automaticDimension

        dataProvider.rootVC = self
        dataProvider.parent = .userList

        guard let imageUnwrapped = UIImage(named: "SOIcon") else {
            preconditionFailure("missing image")
        }
        image = imageUnwrapped
        dataProvider.emptyViewData = (image, topMessage, bottomMessage)

        guard let userID = self.userID else {
            preconditionFailure("User ID missing")
        }
        dataSource.getUser(userID: userID)
        dataSource.getUserQuestions(userID: userID)
        
        self.navigationItem.title = R.string.localizable.userProfile()

        _ = view.subviews.map { $0.isHidden = true }
        tableView.isHidden = true
        showSpinner()
    }

    // MARK: - Actions
    @IBAction func openWebsite(_ sender: Any) {
        if let websiteUrl = dataSource.user?.websiteUrl, let url = URL(string: websiteUrl) {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - Notification Center Selectors
    @objc
    func showUserProfile() {
        guard let user = self.dataSource.user else {
            preconditionFailure("Unable to initialize view with nonexistent question")
        }
        profileImage.isHidden = false
        labelStackView.isHidden = false
        questionStackView.isHidden = false
        badgesStackView.isHidden = false

        dataSource.getImage(url: user.profileImage)
        displayName.text = user.displayName.decodeHTML().string
        displayName.isHidden = false
        if let location = user.location {
            locationLabel.text = location.decodeHTML().string
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }
        questionCountLabel.text = R.string.localizable.questions("\(user.questionCount ?? 0)")
        answerCountLabel.text = R.string.localizable.answers("\(user.answerCount ?? 0)")
        questionCountLabel.isHidden = false
        answerCountLabel.isHidden = false

        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        if let creationDate = formatter.string(for: user.creationDate) {
            creationDateLabel.text = R.string.localizable.joined(creationDate)
            creationDateLabel.isHidden = false
        }

        if let aboutMe = user.aboutMe, !aboutMe.isEmpty {
            aboutMeTextView.isHidden = false
            aboutMeLabel.isHidden = false
            aboutMeTextView.text = aboutMe.decodeHTML().string
            aboutMeTextView.delegate = self
            textViewDidChange(aboutMeTextView)
        } else {
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: badgesStackView.bottomAnchor, multiplier: 1).isActive = true
        }

        if let url = user.websiteUrl, !url.isEmpty {
            websiteButton.layer.cornerRadius = view.frame.size.width / 64
            websiteButton.clipsToBounds = true
            websiteButton.isHidden = false
        } else {
            websiteButton.isHidden = true
        }

        if badgesStackView.viewWithTag(1) != nil {
            // required to remove duplicate view adding when back to first question details view
        } else {
            let badgeStack = UIStackView()
            badgeStack.axis = .horizontal
            badgeStack.distribution = .equalSpacing
            badgeStack.spacing = 20
            badgeStack.tag = 1

            badgesStackView.addArrangedSubview(badgeStack)

            prepareBadge(color: "bronze", user, badgeStack)
            prepareBadge(color: "silver", user, badgeStack)
            prepareBadge(color: "gold", user, badgeStack)
        }
        if let count = user.questionCount, count == 0 {
            topMessage = R.string.localizable.noQuestions()
            bottomMessage = R.string.localizable.userNotPosted()
        }
        dataProvider.emptyViewData = (image, topMessage, bottomMessage)
    }

    @objc
    func showImage() {
        profileImage.image = UIImage(data: dataSource.imageData)
        profileImage.contentMode = .scaleToFill
        profileImage.layer.cornerRadius = view.frame.size.width / 32
        profileImage.clipsToBounds = true
    }

    @objc
    func showQuestionList() {
        tableView.reloadData()
        tableView.isHidden = false
        spinner.removeFromSuperview()
    }

    // MARK: -
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showUserProfile), name: NSNotification.Name("UserProfileLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: NSNotification.Name("ImageLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showQuestionList), name: NSNotification.Name("UserQuestionListLoaded"), object: nil)
    }

    // MARK: - View Builder Methods
    func showSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        spinner.backgroundColor = UIColor.systemBackground
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        spinner.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
    }

    func prepareBadge(color: String, _ user: User, _ badgeStack: UIStackView) {
        if let badges = user.badgeCounts, let count = badges[color], count > 0 {
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
}

extension UserProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        let size = CGSize(width: textView.frame.width, height: .infinity)
        var estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                if estimatedSize.height > 100 {
                    estimatedSize.height = 100
                    textView.isScrollEnabled = true
                }
                constraint.constant = estimatedSize.height
            }
        }
    }
}
