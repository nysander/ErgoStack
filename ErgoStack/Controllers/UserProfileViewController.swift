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
    private var topMessage = "Loading ..."
    private var bottomMessage = "Please wait."

    @IBOutlet var dataProvider: QuestionTableViewDataProvider!
    @IBOutlet var displayName: UILabel!
    @IBOutlet var creationDateLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var questionCountLabel: UILabel!
    @IBOutlet var answerCountLabel: UILabel!
    @IBOutlet var aboutMeTextView: UITextView!
    @IBOutlet var aboutMeLabel: UILabel!
    @IBOutlet var badgesStackView: UIStackView!
    @IBOutlet var mainStackView: UIStackView!

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
        
        self.navigationItem.title = "User Profile"

        mainStackView.isHidden = true
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
        dataSource.getImage(url: user.profileImage)
        displayName.text = user.displayName
        location.text = user.location
        questionCountLabel.text = "Questions: \(user.questionCount ?? 0)"
        answerCountLabel.text = "Answers: \(user.answerCount ?? 0)"

        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        if let creationDate = formatter.string(for: user.creationDate) {
            creationDateLabel.text = "Joined: \(creationDate)"
        }

        websiteButton.layer.cornerRadius = view.frame.size.width / 64
        websiteButton.clipsToBounds = true

        if let aboutMe = user.aboutMe, !aboutMe.isEmpty {
            aboutMeTextView.isHidden = false
            aboutMeLabel.isHidden = false
            aboutMeTextView.text = decodeHTML(string: aboutMe).string
            aboutMeTextView.delegate = self
            textViewDidChange(aboutMeTextView)
        } else {
            aboutMeTextView.isHidden = true
            aboutMeLabel.isHidden = true
        }

        if let url = user.websiteUrl, !url.isEmpty {
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
            topMessage = "No Questions"
            bottomMessage = "User not posted any question yet"
        }
        dataProvider.emptyViewData = (image, topMessage, bottomMessage)

        mainStackView.isHidden = false
        spinner.removeFromSuperview()
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
    }

    // MARK: -
    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showUserProfile), name: NSNotification.Name("UserProfileLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: NSNotification.Name("ImageLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showQuestionList), name: NSNotification.Name("UserQuestionListLoaded"), object: nil)
    }

    //MARK: - View Builder Methods
    func showSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
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

extension UserProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false

        let size = CGSize(width: mainStackView.frame.width, height: .infinity)
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
