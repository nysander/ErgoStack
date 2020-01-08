//
//  MainCoordinator.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navController = navigationController
    }

    func start() {
        if let viewController = R.storyboard.main.questionListViewController() {
            viewController.coordinator = self

            navController.pushViewController(viewController, animated: false)
        } else {
            fatalError("Unable to instantiate main ViewController")
        }
    }

    func showQuestionDetails(questionID: Int) {
        if let viewController = R.storyboard.main.questionDetailsViewController() {
            viewController.questionID = questionID

            viewController.coordinator = self
            navController.pushViewController(viewController, animated: true)
        }
    }

    func showUserProfile(userID: Int) {
        if let viewController = R.storyboard.main.userProfileViewController() {
            viewController.userID = userID

            viewController.coordinator = self
            navController.pushViewController(viewController, animated: true)
        }
    }
}
