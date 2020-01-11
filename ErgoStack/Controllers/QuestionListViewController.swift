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

    var searchController: UISearchController?

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

        // Load search controller asynchronous for faster app start
        DispatchQueue.main.async {
            self.searchController = UISearchController(searchResultsController: nil)
            self.searchController?.searchResultsUpdater = self
            self.searchController?.obscuresBackgroundDuringPresentation = false
            self.searchController?.searchBar.placeholder = "Search Stack Overflow"
            self.definesPresentationContext = true

            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = self.searchController
        }
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
            self.searchController?.searchBar.placeholder = "Search Stack Overflow"
            self.searchController?.searchBar.isUserInteractionEnabled = true
            UserDefaultsConfig.demo = false
            self.navigationItem.rightBarButtonItem?.title = R.string.localizable.enableDemo()
        } else {
            self.searchController?.searchBar.placeholder = "Search Disabled in Demo Mode"
            self.searchController?.searchBar.isUserInteractionEnabled = false
            UserDefaultsConfig.demo = true
            self.navigationItem.rightBarButtonItem?.title = R.string.localizable.disableDemo()
        }
        self.dataSource.questions.removeAll()
        self.dataSource.getQuestions()
    }
}

extension QuestionListViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let query = searchController.searchBar.text, query.count > 3 {
        dataSource.search(query: query)
    }
  }
}

protocol QuestionListProviding {
    var coordinator: MainCoordinator? { get set }
}
