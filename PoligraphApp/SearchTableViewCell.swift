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
//    
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        print("Init with Style called")
//        updateUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    func updateUI() {
        //print("Updating UI for Search Cell")
        if let question = self.question {
            print(questionTextLabel ?? "Text label is nil")
            //print("Setting question text to \(question.text)")
            questionTextLabel?.text = question.text ?? "Error loading question title"
        }
    }

}
