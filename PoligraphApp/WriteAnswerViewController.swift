//
//  WriteAnswerViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class WriteAnswerViewController: UIViewController, UITextViewDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var summaryCharacterCountLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answerBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryHeightConstraint: NSLayoutConstraint!
    
    private struct Storyboard {
        static let ShowAnswersSegueIdentifer = "Show Your Answers"
    }
    
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    @IBAction func submitButton(_ sender: UIBarButtonItem) {
        let submitAnswerController = UIAlertController(title: "Submit Answer", message: "Are you sure you're ready to submit?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            //TODO: Add action
        }
        let submitAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            //TODO: Enforce content
            if let question = self.question {
                question.answer = self.answerTextView.text
                question.summary = self.summaryTextView.text
                question.status = Int32(Question.StatusTypes.answered.rawValue)
                self.performSegue(withIdentifier: Storyboard.ShowAnswersSegueIdentifer, sender: sender)
                if let user = (UIApplication.shared.delegate as! AppDelegate).currentUser {
                    user.addToAnsweredQuestions(question)
                }
            }
        }
        submitAnswerController.addAction(cancelAction)
        submitAnswerController.addAction(submitAction)
        self.present(submitAnswerController, animated: true, completion: nil)
    }
    var keyboardHeight: CGFloat?
    
    let characterLimit = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.lightGray
        //TODO: Fix colors
        if let navBar = self.navigationController?.navigationBar {
            navBar.barTintColor = UIColor.lightGray
            navBar.tintColor = UIColor.black
            navBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        summaryTextView.delegate = self
        answerTextView.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
        updateUI()
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

    func updateUI() {
        if let question = self.question {
            questionTextLabel?.text = question.text!
        }
    }
    
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

    
    // MARK: - UI Text View Delegate Implementation
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == summaryTextView {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.characters.count
            return numberOfChars <= characterLimit
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == summaryTextView {
            let characterCount = textView.text.characters.count
            if characterCount < characterLimit {
                summaryCharacterCountLabel.text = String(characterCount) + " / 140"
                summaryCharacterCountLabel.textColor = UIColor.black
            } else {
                summaryCharacterCountLabel.text = "Character Limit"
                summaryCharacterCountLabel.textColor = UIColor.red
            }
            summaryHeightConstraint.constant = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        } else if textView == answerTextView {
            answerBoxHeightConstraint.constant = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
            if let cursorLocation = textView.selectedTextRange {
                if cursorLocation.end == textView.endOfDocument {
                    if let scrollView = self.view.subviews.first as? UIScrollView {
                        let keyboardHeight = self.keyboardHeight ?? 200.0
                        let offset = CGPoint(x: textView.frame.origin.x, y: textView.frame.maxY - keyboardHeight - 50.0)
                        scrollView.setContentOffset(offset, animated: true)
                    }
                }
            }


        }
        
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier! == Storyboard.ShowAnswersSegueIdentifer {
            if let tabBarController = segue.destination as? UITabBarController {
                tabBarController.selectedIndex = 2
                if let navController = tabBarController.selectedViewController as? UINavigationController {
                    print("So far, so good")
                    if let answersTVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Your Answers") as? YourAnswersTableViewController {
                        navController.pushViewController(answersTVC, animated: false)
                    }
                }
            }
        }
    }

}
