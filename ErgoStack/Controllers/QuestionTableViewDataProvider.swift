//
//  QuestionTableView.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

final class QuestionTableViewDataProvider: NSObject {
    var dataSource = AppDelegate.dataSource
    var rootVC: QuestionsViewController?
    var emptyViewData: (UIImage, String, String)?

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let numberOfRows: Int
        numberOfRows = dataSource.questions.count

        if numberOfRows == 0 {
            tableView.separatorStyle = .none
            tableView.backgroundView?.isHidden = false
            tableView.backgroundView = setupEmptyBackgroundView()
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView?.isHidden = true
        }

        return numberOfRows
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.questionCell.identifier, for: indexPath) as! QuestionCell

        let question = dataSource.questions[indexPath.row]

        cell.configCell(with: question)

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        //
    }

    private func setupEmptyBackgroundView() -> EmptyBackgroundView? {
        guard let emptyViewData = self.emptyViewData else {
            return nil
        }
        let emptyBackgroundView = EmptyBackgroundView(image: emptyViewData.0,
                                                      top: emptyViewData.1,
                                                      bottom: emptyViewData.2)
        return emptyBackgroundView
    }
}

extension QuestionTableViewDataProvider: UITableViewDataSource, UITableViewDelegate { }
