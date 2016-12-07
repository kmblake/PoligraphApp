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
            let questionTextLabel = makeLabel(text: question.text!, frame: CGRect(x: leadingX, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude), isAnswer: answer)
            questionTextLabel.center = CGPoint(x: self.center.x, y: self.center.y * 0.85)
            let summaryLabel = makeLabel(text: question.summary!, frame: CGRect(x: leadingX, y: questionTextLabel.frame.maxY + 5.0, width: width, height: CGFloat.greatestFiniteMagnitude), isAnswer: answer)
            summaryLabel.font = UIFont(name: "Optima-bold", size: 14)
            summaryLabel.sizeToFit()
            summaryLabel.center = CGPoint(x: self.center.x, y: questionTextLabel.frame.maxY + (summaryLabel.bounds.height / 2) + 5.0)
            self.addSubview(questionTextLabel)
            self.addSubview(summaryLabel)
        } else {
            let questionTextLabel = makeLabel(text: question.text!, frame: CGRect(x: leadingX, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude), isAnswer: answer)
            questionTextLabel.center = self.center
            self.addSubview(questionTextLabel)
        }
        
        self.layer.cornerRadius = 30
        self.layer.borderWidth = 6
        if answer {
            self.layer.borderColor = UIColor.polyBlue().cgColor
            self.backgroundColor = UIColor.lightBlue()
        } else {
            self.layer.borderColor = UIColor.lightBlue().cgColor
            self.backgroundColor = UIColor.polyBlue()
        }

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    
    private let widthScale: CGFloat = 0.8
    private let labelFont = UIFont(name: "Optima", size: 17)

    private func makeLabel(text: String, frame: CGRect, isAnswer: Bool) -> UILabel {
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .center
        label.font = labelFont
        label.text = text
        if isAnswer {
            label.textColor = UIColor.darkText
        } else {
            label.textColor = UIColor.white
        }
        
        label.sizeToFit()
        return label
    }

}
