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
        //TODO: Limit user upvotes? Requires tracking if user has upvoted...
        if let question = self.question {
            question.upvotes += 1
            sender.tintColor = UIColor.polyBlue() //TODO: Determine color
            updateUI()
        }
    }
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var upvoteCountLabel: UILabel!
    
    
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
