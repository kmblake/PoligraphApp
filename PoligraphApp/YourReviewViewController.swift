//
//  YourReviewViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/7/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class YourReviewViewController: UIViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var decisionImageView: UIImageView!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBOutlet weak var biasBar: UIBiasBar!
    @IBOutlet weak var biasCaptionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var review: Review? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.polyBlue()
    }

    func updateUI() {
        if let review = self.review {
            if let question = review.question {
                questionTextLabel?.text = question.text
                setDecision(question: question)
            }
            biasBar?.value = review.biasRating
            biasCaptionLabel?.text = biasBar?.getCaption()
            let attributedString = NSMutableAttributedString(string: review.feedbackText ?? "Error loading feedback")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            let textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, attributedString.length))
            feedbackLabel?.attributedText = attributedString
        }
    }
    
    func setDecision(question: Question) {
        if question.status == Int32(Question.StatusTypes.reviewed.rawValue) {
            decisionImageView?.image = #imageLiteral(resourceName: "Checkmark Small")
            decisionLabel?.text = "Answer Accepted"
        } else {
            decisionImageView?.image = #imageLiteral(resourceName: "pending small")
            decisionLabel?.text = "Decision Pending"
        }
    }

}
