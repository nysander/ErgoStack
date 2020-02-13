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

    var dataSource = AppDelegate.dataSource

    private var searchController: UISearchController?
    private var image = UIImage()
    private let topMessage = R.string.localizable.loading()
    private let bottomMessage = R.string.localizable.pleaseWait()

    var isFiltering: Bool {
        if let searchController = searchController {
            return searchController.isActive || !isSearchBarEmpty
        }
        return false
    }

    var isSearchBarEmpty: Bool {
        searchController?.searchBar.text?.isEmpty ?? true
    }

    @IBOutlet var tableView: UITableView!
    @IBOutlet var dataProvider: QuestionTableViewDataProvider!

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

        NotificationCenter.default.addObserver(self, selector: #selector(refreshTableView), name: NSNotification.Name("QuestionListLoaded"), object: nil)

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

            if UserDefaultsConfig.demo {
                self.searchController?.searchBar.placeholder = R.string.localizable.searchDisabled()
                self.searchController?.searchBar.isUserInteractionEnabled = false
            } else {
                self.searchController?.searchBar.placeholder = R.string.localizable.search()
                self.searchController?.searchBar.isUserInteractionEnabled = true
            }
            self.definesPresentationContext = true

            self.navigationItem.hidesSearchBarWhenScrolling = false
            self.navigationItem.searchController = self.searchController
            self.searchController?.searchBar.delegate = self

            let refreshButton = UIBarButtonItem(title: R.string.localizable.refresh(), style: .plain, target: self, action: #selector(self.loadNewQuestions))
            self.navigationItem.leftBarButtonItem = refreshButton
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        dataSource.getQuestions()
    }

    @objc
    func refreshTableView() {
        tableView.reloadData()
    }

    @objc
    func loadNewQuestions() {
        dataSource.getQuestions()
    }

    @objc
    func toggleDemo() {
        if UserDefaultsConfig.demo {
            self.searchController?.searchBar.placeholder = R.string.localizable.search()
            self.searchController?.searchBar.isUserInteractionEnabled = true
            UserDefaultsConfig.demo = false
            self.navigationItem.rightBarButtonItem?.title = R.string.localizable.enableDemo()
        } else {
            self.searchController?.searchBar.placeholder = R.string.localizable.searchDisabled()
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
        // Get all questions when search is cancelled
        if !isFiltering {
            dataSource.getQuestions()
        }
    }
}

extension QuestionListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Trigger updating search results after given delay - debouncing
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(getSearchResults), object: nil)
        self.perform(#selector(getSearchResults), with: nil, afterDelay: 0.25)
    }

    @objc
    func getSearchResults() {
        if let query = searchController?.searchBar.text, query.count > 2 && isFiltering {
            dataSource.search(query: query)
        }
    }
}
