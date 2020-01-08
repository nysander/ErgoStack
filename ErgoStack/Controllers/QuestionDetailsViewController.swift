//
//  QuestionDetailsViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

class QuestionDetailsViewController: UIViewController {
    var questionID: Int?
    weak var coordinator: MainCoordinator?
    
    var dataSource = AppDelegate.dataSource

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let questionID = questionID else {
            preconditionFailure("Unable to initialise View Controller without Question ID")
        }

        dataSource.getQuestion(questionID: questionID)
    }
}
