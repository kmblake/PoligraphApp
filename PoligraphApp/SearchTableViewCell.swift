//
//  SearchTableViewCell.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/23/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextLabel: UILabel!
    
    var question: Question? {
        didSet{
            updateUI()
        }
    }
    
    func updateUI() {
        if let question = self.question {
            questionTextLabel?.text = question.text ?? "Error loading question title"
        }
    }

}
