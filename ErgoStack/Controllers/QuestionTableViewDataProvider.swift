//
//  QuestionTableView.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

enum ParentView {
    case list
    case userList
}

import UIKit

final class QuestionTableViewDataProvider: NSObject {
    var dataSource = AppDelegate.dataSource
    var rootVC: QuestionListProviding?
    var emptyViewData: (UIImage, String, String)?
    var parent: ParentView?

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let parent = self.parent else {
            preconditionFailure("parent view not set")
        }
        let numberOfRows: Int
        switch parent {
        case .list:
            numberOfRows = dataSource.questions.count
        case .userList:
            numberOfRows = dataSource.userQuestions.count
        }
        
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

        guard let parent = self.parent else {
            preconditionFailure("parent view not set")
        }
        let question: Question
        switch parent {
        case .list:
            question = dataSource.questions[indexPath.row]
        case .userList:
            question = dataSource.userQuestions[indexPath.row]
        }

        cell.configCell(with: question, for: parent)

        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let parent = self.parent else {
            preconditionFailure("parent view not set")
        }
        let questionID: Int
        switch parent {
        case .list:
            questionID = dataSource.questions[indexPath.row].questionId
        case .userList:
            questionID = dataSource.userQuestions[indexPath.row].questionId
        }

        rootVC?.coordinator?.showQuestionDetails(questionID: questionID)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch parent {
        case .userList:
            return R.string.localizable.userQuestions()
        default:
            return nil
        }
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
