//
//  BrowseQuestionTableViewCell.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/20/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class BrowseQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    var question: Question? {
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI() {
        //TODO: Implement. See Smashtag
        print("Updating UI")
        
        if let question = self.question {
            questionTextLabel.text = question.text! //Force unwrap question text here
            summaryLabel.text = question.summary! //This is force unwrap b/c summary is required
            
        }
    }

}
