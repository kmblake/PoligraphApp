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
    
    private struct Storyboard {
        static let ShowBrowseSegue = "Show Browse"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //let contentViewFrame = self.view.subviews[0].subviews[0].frame
        //self.view.subviews[0].frame = CGRect(x: 0, y: 0, width: contentViewFrame.width, height: contentViewFrame.height + 200)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //let contentViewFrame = self.view.subviews[0].subviews[0].frame
        //self.view.subviews[0].subviews[0].frame = CGRect(x: 0, y: 0, width: contentViewFrame.width, height: contentViewFrame.height + 200)
        if let scrollView = self.view.subviews[0] as? UIScrollView {
            let size = scrollView.contentSize
            answerText.sizeToFit()
            print("Label height = \(answerText.frame.height)")
            scrollView.contentSize = CGSize(width: size.width, height: size.height + 1.6 * answerText.frame.height)
        }
        
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

            //TODO: Set answer image, if there is one
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
                                    self.answerImage.image = UIImage(data: imageData)
                                    self.answererImage.layer.cornerRadius = self.answererImage.frame.size.width / 2
                                    self.answererImage.clipsToBounds = true
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
                                        self.spinner?.stopAnimating()
                                        self.answererImage.image = UIImage(data: answererImageData)
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
            if let browseVC = segue.destination as? BrowseViewController {
                //TODO do stuff?
            }
        }
    }

}
