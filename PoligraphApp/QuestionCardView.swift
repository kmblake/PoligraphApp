//
//  QuestionCardView.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit
//import QuartzCore

class QuestionCardView: UIView {

    init(frame: CGRect, question: Question, answer: Bool) {
        super.init(frame: frame)
        addLabel(question: question, is_answer: answer)
        //TODO: Rounded Edges
        self.layer.cornerRadius = 30
        
        self.layer.borderWidth = 6
        if answer {
            self.layer.borderColor = UIColor.lightBlue().cgColor
            self.backgroundColor = UIColor.polyBlue()
        } else {
            self.layer.borderColor = UIColor.polyBlue().cgColor
            self.backgroundColor = UIColor.lightBlue()
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let widthScale: CGFloat = 0.8
    
    func addLabel(question: Question, is_answer: Bool) {
        let width = self.frame.width * widthScale
        let labelFrame = CGRect(x: ((self.frame.width - width) / 2.0), y: 0.0, width: width, height: self.frame.height)
        let label = UILabel(frame: labelFrame)
        label.center = self.center
        label.textAlignment = .center
        label.font = UIFont(name: "Optima", size: 20)
        if is_answer {
            label.textColor = UIColor.white
        } else {
            label.textColor = UIColor.white
        }
        label.text = question.text!
        label.numberOfLines = 0
        self.addSubview(label)
    }

}
