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

    private let image = UIImage()
    private let topMessage = "top message"
    private let bottomMessage = "bottom message"

    @IBOutlet var dataProvider: QuestionTableViewDataProvider!
    @IBOutlet var displayName: UILabel!
    @IBOutlet var creationDateLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var questionCountLabel: UILabel!
    @IBOutlet var answerCountLabel: UILabel!
    @IBOutlet var aboutMeTextView: UITextView!
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

    func showSpinner() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    @IBAction func openWebsite(_ sender: Any) {
        if let websiteUrl = dataSource.user?.websiteUrl, let url = URL(string: websiteUrl) {
            UIApplication.shared.open(url)
        }
    }

    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showUserProfile), name: NSNotification.Name("UserProfileLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: NSNotification.Name("ImageLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showQuestionList), name: NSNotification.Name("UserQuestionListLoaded"), object: nil)
    }

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

        if let url = user.websiteUrl, !url.isEmpty {
            websiteButton.isHidden = false
        } else {
            websiteButton.isHidden = true
        }
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
}
