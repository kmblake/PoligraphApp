//
//  WriteAnswerViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class WriteAnswerViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var answerImageView: UIImageView!
    @IBOutlet weak var summaryCharacterCountLabel: UILabel!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var answerBoxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryTextView: UITextView!
    
    var question: Question? {
        didSet {
            updateUI()
        }
    }
    

    
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
        
        updateUI()
        // Do any additional setup after loading the view.
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
            let keyboardHeight = keyboardFrame.height
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
              //  self.bottomConstraint.constant = keyboardFrame.size.height + 20
            })
        }

    }
    
    func keyboardDidHide() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
