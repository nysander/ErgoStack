//
//  UserProfileViewController.swift
//  ErgoStack
//
//  Created by Pawel Madej on 08/01/2020.
//  Copyright © 2020 Pawel Madej. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet var displayName: UILabel!
    @IBOutlet var creationDate: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var websiteButton: UIButton!
    @IBOutlet var questionCountLabel: UILabel!
    @IBOutlet var answerCountLabel: UILabel!
    @IBOutlet var aboutMeTextView: UITextView!
    @IBOutlet var badgesStackView: UIStackView!
    @IBOutlet var mainStackView: UIStackView!

    @IBOutlet var userQuestionsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
