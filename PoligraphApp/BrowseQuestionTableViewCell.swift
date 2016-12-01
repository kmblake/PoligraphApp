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
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    var question: Question? {
        didSet{
            updateUI()
        }
    }
    
//    internal var aspectConstraint : NSLayoutConstraint? {
//        didSet {
//            if oldValue != nil {
//                questionImage.removeConstraint(oldValue!)
//            }
//            if aspectConstraint != nil {
//                questionImage.addConstraint(aspectConstraint!)
//            }
//        }
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        aspectConstraint = nil
//    }
//    
//    func setQuestionImage(image: UIImage) {
//        let aspectRatio = image.size.width / image.size.height
//        let aspectConstraint = NSLayoutConstraint(item: questionImage, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: questionImage, attribute: NSLayoutAttribute.height, multiplier: aspectRatio, constant: 0.0)
//        questionImage.addConstraint(aspectConstraint)
//    }
   
    func updateUI() {
        if let question = self.question {
            questionTextLabel.text = question.text! //Force unwrap question text here
            summaryLabel.text = question.summary! //This is force unwrap b/c summary is required
            
            if let imageURLString = question.image {
                spinner.startAnimating()
                if let imageURL = URL(string: imageURLString) {
                    DispatchQueue.global(qos: .background).async {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            DispatchQueue.main.async {
                                if imageURLString == question.image {
                                    self.spinner.stopAnimating()
                                    if let image = UIImage(data: imageData) {
                                        self.questionImage.image = image
                                    }
                                } else {
                                    print("Ignoring data returned from URL \(imageURL)")
                                }
                            }
                        }
                    }
                }
            }

            
        }
    }

}
