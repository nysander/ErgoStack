//
//  ViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

class QuestionListViewController: UIViewController, QuestionListProviding {
    weak var coordinator: MainCoordinator?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: QuestionTableViewDataProvider!

    private var image = UIImage()
    private let topMessage = R.string.localizable.loading()
    private let bottomMessage = R.string.localizable.pleaseWait()

    var dataSource = AppDelegate.dataSource

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.rowHeight = UITableView.automaticDimension

        dataProvider.rootVC = self
        dataProvider.parent = .list

        guard let imageUnwrapped = UIImage(named: "SOIcon") else {
            preconditionFailure("missing image")
        }
        image = imageUnwrapped
        dataProvider.emptyViewData = (image, topMessage, bottomMessage)

        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("QuestionListLoaded"), object: nil)

        if UserDefaultsConfig.demo {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.disableDemo(), style: .plain, target: self, action: #selector(toggleDemo))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: R.string.localizable.enableDemo(), style: .plain, target: self, action: #selector(toggleDemo))
        }

        self.navigationItem.title = R.string.localizable.questionList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.getQuestions()
    }

    @objc
    func refresh() {
        tableView.reloadData()
    }

    @objc
    func toggleDemo() {
        if UserDefaultsConfig.demo {
            UserDefaultsConfig.demo = false
            self.navigationItem.rightBarButtonItem?.title = R.string.localizable.enableDemo()
            dataSource.questions.removeAll()
            dataSource.getQuestions()
        } else {
            UserDefaultsConfig.demo = true
            self.navigationItem.rightBarButtonItem?.title = R.string.localizable.disableDemo()
            dataSource.questions.removeAll()
            dataSource.getQuestions()
        }
    }
}

protocol QuestionListProviding {
    var coordinator: MainCoordinator? { get set }
}
