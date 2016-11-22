//: Playground - noun: a place where people can play

import UIKit


func parseJSON() {
    //let testJSON = "{ \"users\": [{ \"id\": 1, \"firstName\": \"George\", \"lastName\": \"Washington\", \"bio\": \"US History Buff\", \"credentials\": \"Former U.S. President, General\"}]}"
    let testJSON = "{\"names\": [\"Bob\", \"Tim\", \"Tina\"]}"
    let data = testJSON.data(using: String.Encoding.utf8, allowLossyConversion: false)!
    
    do {
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
        if let names = json["names"] as? [String] {
            print(names)
        }
    } catch let error as NSError {
        print("Failed to load JSON: \(error.localizedDescription)")
    }
}

parseJSON()
