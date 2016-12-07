//
//  WriteReviewViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/3/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets
    
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var biasBarSlider: UIBiasBar!
    @IBOutlet weak var feedbackTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recommendationPickerView: UIPickerView!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var submitButtonOutlet: UIBarButtonItem!

    @IBAction func changedSlider(_ sender: UIBiasBar) {
        didSetBiasBar = true
        checkSubmitConditions()
    }
    
    @IBAction func pickButton(_ sender: UIButton) {
        recommendationPickerView.isHidden = !recommendationPickerView.isHidden
    }
    
    @IBAction func submitButton(_ sender: UIBarButtonItem) {
        let submitAnswerController = UIAlertController(title: "Submit Answer", message: "Are you sure you're ready to submit?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //TODO: Add action
        }
        let submitAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let user = (UIApplication.shared.delegate as! AppDelegate).currentUser!
            if let question = self.question {
                _ = Review.addNewReview(
                    feedbackText: self.feedbackTextView.text,
                    recommendation: Review.RecommendationTypes[self.recommendationLabel.text!]!,
                    biasRating: self.biasBarSlider.value,
                    question: question,
                    reviewer: user,
                    inManagedObjectContext: self.moc)
            }
            self.performSegue(withIdentifier: Storyboard.ShowYourReviewsSegue, sender: sender)
            //TODO: Check if this adds the user as the a question reviewer
        }
        submitAnswerController.addAction(cancelAction)
        submitAnswerController.addAction(submitAction)
        self.present(submitAnswerController, animated: true, completion: nil)
    }
    
    var question: Question?
    
    let recommendations = ["Accept", "Needs Revision", "Reject"]
    
    var keyboardHeight: CGFloat?
    
    var didSetBiasBar = false
    
    private struct Storyboard {
        static let ShowAnswerPreviewSegue = "Show Answer Preview"
        static let ShowYourReviewsSegue = "Show Your Reviews"
        static let feedbackPlaceholderText = "Feedback"
        static let recommendationLabelPlaceholderText = "Not Set"
    }
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        feedbackTextView.delegate = self
        recommendationPickerView.delegate = self
        recommendationPickerView.dataSource = self
        
        biasBarSlider.isContinuous = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        self.performSegue(withIdentifier: Storyboard.ShowAnswerPreviewSegue, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         setNavigationBarColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = UIColor.polyBlue()
            navBar.tintColor = UIColor.white
            navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        }
        UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.polyBlue()
    }
    
    private func checkSubmitConditions() {
        if !feedbackTextView.text.isEmpty &&
            feedbackTextView.text != Storyboard.feedbackPlaceholderText &&
            didSetBiasBar  &&
            recommendationLabel.text! != Storyboard.recommendationLabelPlaceholderText {
            submitButtonOutlet.isEnabled = true
            submitButtonOutlet.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.buttonBlue()], for: .normal)
        } else {
            submitButtonOutlet.isEnabled = false
            submitButtonOutlet.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.gray], for: .normal)
        }
    }
    
    private func setNavigationBarColors() {
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.polyGray()
        //TODO: Fix colors
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = UIColor.polyGray()
            navBar.tintColor = UIColor.black
            navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
            submitButtonOutlet.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.gray], for: .normal)
        }
        
    }
    
    // MARK: - Keyboard Notification Functions
    
    func keyboardDidShow(notification: NSNotification) {
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardFrame.height
            bottomConstraint.constant = keyboardHeight! + 20
        }
        
    }
    
    func keyboardDidHide() {
        bottomConstraint.constant = 0.0
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Text View Delegate Implementation
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView == feedbackTextView {
//            if textView.text == Storyboard.feedbackPlaceholderText {
//                textView.text = ""
//            }
//        }
//    }
    
    func textViewDidChange(_ textView: UITextView) {
        checkSubmitConditions()
        if textView == feedbackTextView {
            checkSubmitConditions()
            feedbackTextViewHeightConstraint.constant = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        }
        
    }

    // MARK: - Picker View Delegate Implemenation
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recommendations[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recommendationLabel.text = recommendations[row]
        checkSubmitConditions()
    }
    
    // MARK: - Picker View Data Source Implementation
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recommendations.count
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ShowAnswerPreviewSegue {
            if let answeredQuestionVC = segue.destination as? AnsweredQuestionViewController {
                answeredQuestionVC.previewMode = true
                if let question = self.question {
                    answeredQuestionVC.question = question
                }
            }
        }
        if segue.identifier! == Storyboard.ShowYourReviewsSegue {
            if let tabBarController = segue.destination as? UITabBarController {
                tabBarController.selectedIndex = 3
                if let navController = tabBarController.selectedViewController as? UINavigationController {
                    if let reviewTVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Your Reviews") as? YourReviewsTableViewController {
                        navController.pushViewController(reviewTVC, animated: false)
                    }
                }
            }
        }
    }


}
