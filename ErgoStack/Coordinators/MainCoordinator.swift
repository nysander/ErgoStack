//
//  MainCoordinator.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator, UISplitViewControllerDelegate {
    var splitViewController = UISplitViewController()
    var navController = CoordinatedNavigationController()

    init() {
        navController.navigationBar.prefersLargeTitles = true
        navController.coordinator = self

        if let viewController = R.storyboard.main.questionListViewController(),
            let detailViewController = R.storyboard.main.selectFirstQuestionViewController() {
            viewController.coordinator = self

            navController.viewControllers = [viewController]

            splitViewController.viewControllers = [navController, detailViewController]

            if #available(iOS 13, *) {
                if splitViewController.traitCollection.userInterfaceIdiom == .phone {
                    // Without this workaround, there's a nasty color behind pushed view controllers, only in dark mode on iOS 13.
                    splitViewController.view.backgroundColor = .systemBackground
                }
            }

            // make this split view controller behave sensibly on iPad
            splitViewController.preferredDisplayMode = .allVisible
            splitViewController.delegate = SplitViewControllerDelegate.shared
        } else {
            fatalError("Unable to instantiate main ViewController")
        }
    }

    func showQuestionDetails(questionID: Int) {
        if let viewController = R.storyboard.main.questionDetailsViewController() {
            viewController.questionID = questionID
            viewController.coordinator = self

            let navigatedVC = UINavigationController(rootViewController: viewController)
            splitViewController.showDetailViewController(navigatedVC, sender: self)
        }
    }

    func showUserProfile(userID: Int) {
        if let viewController = R.storyboard.main.userProfileViewController() {
            viewController.userID = userID
            viewController.coordinator = self

            let navigatedVC = UINavigationController(rootViewController: viewController)
            navigatedVC.navigationController?.navigationItem.hidesBackButton = false
            splitViewController.showDetailViewController(navigatedVC, sender: self)
        }
    }
}
