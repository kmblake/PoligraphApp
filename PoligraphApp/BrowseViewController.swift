//
//  FirstViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/13/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
        if let userOne = User.getUser(id: 1, inManagedObjectContext: moc) {
            print("First Name: \(userOne.firstName)")
            print("Last Name: \(userOne.lastName)")
        } else {
            print("User load failed")
        }
        if let questions = Question.searchQuestions(type: Question.StatusTypes.asked, text: "what is", inManagedObjectContext: moc) {
            let firstQuestion = questions[0]
            print("Text: \(firstQuestion.text)")
            print("Asker: \(firstQuestion.asker?.firstName)")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

