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
    
    init(frame: CGRect, question: Question, answer: Bool, includeSummary: Bool) {
        super.init(frame: frame)
        let width = self.frame.width * widthScale
        let leadingX = (self.frame.width - width) / 2.0
        
        
        if includeSummary {
            let questionTextLabel = makeLabel(text: question.text!, frame: CGRect(x: leadingX, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            questionTextLabel.center = CGPoint(x: self.center.x, y: self.center.y * 0.85)
            let summaryLabel = makeLabel(text: question.summary!, frame: CGRect(x: leadingX, y: questionTextLabel.frame.maxY + 5.0, width: width, height: CGFloat.greatestFiniteMagnitude))
            summaryLabel.textColor = UIColor.lightGray
            summaryLabel.font = UIFont(name: "Optima", size: 14)
            summaryLabel.sizeToFit()
            summaryLabel.center = CGPoint(x: self.center.x, y: questionTextLabel.frame.maxY + (summaryLabel.bounds.height / 2) + 5.0)
            self.addSubview(questionTextLabel)
            self.addSubview(summaryLabel)
        } else {
            let questionTextLabel = makeLabel(text: question.text!, frame: CGRect(x: leadingX, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            questionTextLabel.center = self.center
            self.addSubview(questionTextLabel)
        }
        
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
    private let labelFont = UIFont(name: "Optima", size: 17)
    
//    func addLabel(question: Question) {
//        let width = self.frame.width * widthScale
//        let labelFrame = CGRect(x: ((self.frame.width - width) / 2.0), y: 0.0, width: width, height: self.frame.height)
//        let label = UILabel(frame: labelFrame)
//        label.center = self.center
//        label.textAlignment = .center
//        label.font = UIFont(name: "Optima", size: 17)
//        label.text = question.text!
//        label.numberOfLines = 0
//        self.addSubview(label)
//    }
    
    private func makeLabel(text: String, frame: CGRect) -> UILabel {
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.font = labelFont
        label.text = text
        label.sizeToFit()
        return label
    }
    
    /*
    private func addSummary(question: Question, questionTextLabel: UILabel) {
        let width = self.frame.width * widthScale
        let label = UILabel(frame: CGRect(x: 0, y: questionTextLabel.frame.maxY + 5.0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.center = self.center
        label.textAlignment = .center
        label.font = labelFont
        label.text = question.summary ?? ""
        label.sizeToFit()
        self.addSubview(label)
    }
    
    private func addLabel(question: Question) -> UILabel {
        let width = self.frame.width * widthScale
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        //label.center = self.center
        label.textAlignment = .center
        label.font = labelFont
        label.text = question.text!
        label.sizeToFit()
        self.addSubview(label)
        return label
    }
    */
}
