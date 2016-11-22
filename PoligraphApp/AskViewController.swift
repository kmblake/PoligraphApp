//
//  SecondViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/13/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class AskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func parseJSON() {
        let testJSON = "{ \"users\": [{ \"id\": 1, \"firstName\": \"George\", \"lastName\": \"Washington\", \"bio\": \"US History Buff\", \"credentials\": \"Former U.S. President, General\"}]}"
        let data = testJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            if let users = json["users"] as? [User] {
                for user in users {
                    print(user.id)
                }
            }
        } catch let error as NSError {
            print("Failed to load JSON: \(error.localizedDescription)")
        }
    }
    
    /*
    func makeUserJSON() {
        let moc = (UIApplication.shared.delegate as! AppDelegate).getContext()
        if let newUser = User.addNewUser(id: 1, firstName: "George", lastName: "Washington", bio: "U.S. History Buff", credentials: "Former U.S. President, General", inManagedObjectContext: moc) {
            let json = JSONSerialization
        }
    }
    */

}

