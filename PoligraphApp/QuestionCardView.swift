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

    init(frame: CGRect, question: Question) {
        super.init(frame: frame)
        addLabel(question: question)
        //TODO: Rounded Edges
        self.layer.borderWidth = 6
        self.backgroundColor = UIColor.white
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
    
    func addLabel(question: Question) {
        let width = self.frame.width * widthScale
        let labelFrame = CGRect(x: ((self.frame.width - width) / 2.0), y: 0.0, width: width, height: self.frame.height)
        let label = UILabel(frame: labelFrame)
        label.center = self.center
        label.textAlignment = .center
        label.text = question.text!
        label.numberOfLines = 0
        self.addSubview(label)
    }

}
