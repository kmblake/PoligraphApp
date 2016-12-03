//
//  WriteAnswerViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class WriteAnswerViewController: UIViewController {
    
    @IBOutlet weak var questionTextLabel: UILabel!

    var question: Question? {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func updateUI() {
        if let question = self.question {
            questionTextLabel?.text = question.text!
        }
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
