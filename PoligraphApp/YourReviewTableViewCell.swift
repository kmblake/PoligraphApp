//
//  YourReviewTableViewCell.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/3/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class YourReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var questionSummaryLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let question = self.question {
            questionTextLabel?.text = question.text!
            questionSummaryLabel?.text = question.summary ?? "Error loading question summary"
            if question.status == Int32(Question.StatusTypes.reviewed.rawValue) {
                statusImageView.image = #imageLiteral(resourceName: "Checkmark Small")
                statusImageView.tintColor = UIColor.polyBlue()
            } else {
                statusImageView.image = #imageLiteral(resourceName: "pending small")
                statusImageView.tintColor = UIColor(red: 86.0/255.0, green: 204.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            }
            
        }
    }

}
