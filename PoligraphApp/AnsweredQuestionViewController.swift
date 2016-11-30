//
//  AnsweredQuestionViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/21/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class AnsweredQuestionViewController: UIViewController {

    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answererLabel: UILabel!
    @IBOutlet weak var answererBio: UILabel!
    @IBOutlet weak var answererImage: UIImageView!
    @IBOutlet weak var answerImage: UIImageView!
    @IBOutlet weak var answerSummary: UILabel!
    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var answerBiasSlider: UISlider!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    
    // MARK: - Actions
    @IBAction func reportAnswerButton(_ sender: UIButton) {
        print("Report button pressed")
        
        let reportQuestionController = UIAlertController(title: "Report Answer", message: "We're sorry. Please tell us what's wrong with this answer.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //TODO: Add action
        }
        let inaccurateAction = UIAlertAction(title: "Inaccurate", style: .default) { (action) in
            //TODO: Add action
        }
        let offensiveAction = UIAlertAction(title: "Offensive", style: .default) { (action) in
            //TODO: Add action
        }
        let otherAction = UIAlertAction(title: "Other", style: .default) { (action) in
            //TODO: Add action
        }
        
        reportQuestionController.addAction(cancelAction)
        reportQuestionController.addAction(inaccurateAction)
        reportQuestionController.addAction(offensiveAction)
        reportQuestionController.addAction(otherAction)
        
        self.present(reportQuestionController, animated: true, completion: nil)
    }

    
    private struct Storyboard {
        static let ShowBrowseSegue = "Show Browse"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    var question: Question? {
        didSet{
            print("Question Set")
            updateUI()
        }
    }
    
    func updateUI() {
        
        //Reset existing info
//        questionTextLabel?.text = nil
//        answererLabel?.text = nil
//        answererBio?.text = nil
//        answererImage?.image = nil
//        answerImage?.image = nil
//        answerSummary?.text = nil
//        answerText?.text = nil
        
        //Load new info from question (if any)
        if let question = self.question {
            print("Updating Question Text to: \(question.text!)")
            questionTextLabel?.text = question.text!
            print("\(questionTextLabel)")
            answerSummary?.text = question.summary ?? "Error loading summary" //TODO Attributed/rich text?
            let attributedString = NSMutableAttributedString(string: question.answer ?? "Error loading answer")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6 // Whatever line spacing you want in points
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            let textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, attributedString.length))
            answerText?.attributedText = attributedString

            print("Bias Rating: \(question.biasRating)")
            answerBiasSlider?.setValue(question.biasRating, animated: false)
            //TODO: Upvotes
            
            if let imageURLString = question.image {
                if let imageURL = URL(string: imageURLString) {
                    DispatchQueue.global(qos: .background).async {
                        if let imageData = try? Data(contentsOf: imageURL) {
                            DispatchQueue.main.async {
                                if imageURLString == question.image {
                                    print("Image assigned")
                                    self.spinner?.stopAnimating()
                                    self.answerImage.image = UIImage(data: imageData)
                                } else {
                                    print("Ignoring data returned from URL \(imageURL)")
                                }
                            }
                        }
                    }
                }
            }
            
            if let answerer = question.answerer {
                spinner?.startAnimating()
                answererLabel?.text = answerer.firstName! + " " + answerer.lastName!
                answererBio?.text = answerer.bio ?? ""
                if let answererImageURLString = answerer.image {
                    if let answererImageURL = URL(string: answererImageURLString) {
                        DispatchQueue.global(qos: .background).async {
                            if let answererImageData = try? Data(contentsOf: answererImageURL) {
                                DispatchQueue.main.async {
                                    if answererImageURLString == answerer.image {
                                        print("Answerer Image Assigned")
                                        self.answererImage.image = UIImage(data: answererImageData)
                                        self.answererImage.layer.cornerRadius = self.answererImage.frame.size.width / 2
                                        self.answererImage.clipsToBounds = true
                                    } else {
                                        print("Ignoring data returned from URL \(answererImageURL)")
                                    }
                                }
                            }
                        }
                    }
                }
                
            } else {
                print("Error loading question answerer")
            }
            
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier! == Storyboard.ShowBrowseSegue {
            if let _ = segue.destination as? BrowseViewController {
                //TODO do stuff?
            }
        }
    }

}
