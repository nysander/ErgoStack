//
//  ViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Combine
import UIKit

class QuestionListViewController: UIViewController {
    weak var coordinator: MainCoordinator?

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: QuestionTableViewDataProvider!

    private let image = UIImage()
    private let topMessage = "top message"
    private let bottomMessage = "bottom message"

    var dataSource = AppDelegate.dataSource

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        tableView.rowHeight = UITableView.automaticDimension

        dataProvider.rootVC = self

        dataProvider.emptyViewData = (image, topMessage, bottomMessage)

        #warning("TODO: set navigation title etc")
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("QuestionListLoaded"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.getQuestions()
    }

    @objc
    func refresh() {
        tableView.reloadData()
    }
}
