//
//  YourQuestionsTableViewCell.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/30/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class YourQuestionsTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var questionStatusImageView: UIImageView!
    
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let question = self.question {
            questionTextLabel.text = question.text!
            if question.status == Int32(Question.StatusTypes.reviewed.rawValue) {
                questionStatusImageView.image = #imageLiteral(resourceName: "Checkmark Small")
                questionStatusImageView.tintColor = UIColor.polyBlue()
            } else {
                questionStatusImageView.image = #imageLiteral(resourceName: "pending small")
                questionStatusImageView.tintColor = UIColor(red: 86.0/255.0, green: 204.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            }
            
        }
    }

}
