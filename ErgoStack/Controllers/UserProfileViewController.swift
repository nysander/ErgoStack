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

    private let image = UIImage()
    private let topMessage = "top message"
    private let bottomMessage = "bottom message"

    @IBOutlet var dataProvider: QuestionTableViewDataProvider!

    @IBOutlet var displayName: UILabel!
    @IBOutlet var creationDate: UILabel!
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

        guard let userID = self.userID else {
            preconditionFailure("User ID missing")
        }
        dataSource.getUser(userID: userID)

        registerNotificationObservers()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.rowHeight = UITableView.automaticDimension

        dataProvider.rootVC = self

        dataProvider.emptyViewData = (image, topMessage, bottomMessage)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func registerNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showUserProfile), name: NSNotification.Name("UserProfileLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showImage), name: NSNotification.Name("ImageLoaded"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showQuestionList), name: NSNotification.Name("UserQuestionListLoaded"), object: nil)

    }

    @objc
    func showUserProfile() {

    }

    @objc
    func showImage() {

    }

    @objc
    func showQuestionList() {

    }
}
