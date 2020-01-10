//
//  SplitViewControllerDelegate.swift
//  ErgoStack
//
//  Created by Pawel Madej on 10/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

class SplitViewControllerDelegate: UISplitViewControllerDelegate {
    static let shared = SplitViewControllerDelegate()

    private init() { }

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if secondaryViewController is SelectFirstQuestionViewController {
            return true
        } else {
            return false
        }
    }
}
