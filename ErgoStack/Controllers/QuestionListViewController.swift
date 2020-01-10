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
    private let topMessage = "Loading ..."
    private let bottomMessage = "Please wait"

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
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Disable demo", style: .plain, target: self, action: #selector(toggleDemo))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Enable demo", style: .plain, target: self, action: #selector(toggleDemo))
        }

        self.navigationItem.title = "Question List"
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
            self.navigationItem.rightBarButtonItem?.title = "Enable demo"
            dataSource.questions.removeAll()
            dataSource.getQuestions()
        } else {
            UserDefaultsConfig.demo = true
            self.navigationItem.rightBarButtonItem?.title = "Disable demo"
            dataSource.questions.removeAll()
            dataSource.getQuestions()
        }
    }
}

protocol QuestionListProviding {
    var coordinator: MainCoordinator? { get set }
}
