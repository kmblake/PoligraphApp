//
//  UnansweredQuestionViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 11/29/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class UnansweredQuestionViewController: UIViewController {

    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func upvoteButton(_ sender: UIButton) {
        if let question = self.question {
            if question.userDidUpvote {
                question.upvotes -= 1
                question.userDidUpvote = false
                updateUI()
            } else {
                question.upvotes += 1
                question.userDidUpvote = true
                updateUI()
            }
        }
    }
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    @IBOutlet weak var upvoteButtonOutlet: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        updateUI()
    }

    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let question = self.question {
            let noun = question.upvotes == 1 ? "person wants" : "people want"
            upvoteCountLabel?.text = "\(question.upvotes) \(noun) to know"
            if question.userDidUpvote {
                upvoteButtonOutlet?.tintColor = UIColor.polyBlue()
            } else {
                upvoteButtonOutlet?.tintColor = UIColor.gray
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
