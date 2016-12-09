//
//  YourAnswerTableViewCell.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class YourAnswerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var questionSummaryLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    
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
