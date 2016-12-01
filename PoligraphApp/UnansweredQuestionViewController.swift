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
    
    @IBOutlet weak var answerStatusImage: UIImageView!
    @IBOutlet weak var answerStatusText: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        questionTextLabel?.text = question?.text
        updateUI()
        setAnswerStatus()
    }

    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    func getStatus()-> Question.StatusTypes {
        guard let status = Question.StatusTypes(rawValue: Int((question?.status)!)) else {
            return Question.StatusTypes.asked
        }
        return status
    }
    
    
    func setAnswerStatus() {
        let status = getStatus()
        switch status {
        case .asked:
            answerStatusText?.text = "Awaiting answerer"
            answerStatusImage?.image = UIImage(named: "looking-for-answerer.png")
        case .unfinishedAnswer:
            answerStatusText?.text = "Answer in progress"
            answerStatusImage?.image = UIImage(named: "answer-in-progress.png")
        case .answered:
            answerStatusText?.text = "Answer under review"
            answerStatusImage?.image = UIImage(named: "review-in-progress.png")
        default:
            answerStatusText?.text = "Awaiting answerer"
            answerStatusImage?.image = UIImage(named: "looking-for-answerer.png")
        }
        answerStatusImage?.image = answerStatusImage?.image!.withRenderingMode(.alwaysTemplate)
        answerStatusImage?.tintColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    }
    
    func updateUI() {
        if let question = self.question {
            let noun = question.upvotes == 1 ? "person wants" : "people want"
            upvoteCountLabel?.text = "\(question.upvotes) \(noun) to know"
            if question.userDidUpvote {
                upvoteButtonOutlet?.tintColor = UIColor.polyBlue()
                upvoteButtonOutlet?.setTitleColor(UIColor.polyBlue(), for: .normal)
            } else {
                upvoteButtonOutlet?.tintColor = UIColor.lightGray
                upvoteButtonOutlet?.setTitleColor(UIColor.gray, for: .normal)
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
