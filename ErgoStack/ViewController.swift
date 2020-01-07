//
//  ViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 07/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import Combine
import UIKit

class ViewController: UIViewController {
    var dataSource = AppDelegate.dataSource

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.getQuestions()
        // Do any additional setup after loading the view.
    }


}

