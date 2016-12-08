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
            }
            biasBar?.value = review.biasRating
            biasCaptionLabel?.text = biasBar?.getCaption()
            feedbackLabel?.text = review.feedbackText!
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
