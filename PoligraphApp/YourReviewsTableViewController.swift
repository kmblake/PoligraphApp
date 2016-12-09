//
//  YourReviewsTableViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/3/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class YourReviewsTableViewController: UITableViewController {
    
    var reviews = [Review]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
    
    private struct Storyboard {
        static let ReviewCellIdentifier = "Review Cell"
        static let ShowReviewSegueIdentifier = "Show Your Review"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userReviews = Review.loadReviews(forUser: (UIApplication.shared.delegate as! AppDelegate).currentUser!) {
            reviews = userReviews
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ReviewCellIdentifier, for: indexPath)

        if let reviewCell = cell as? YourReviewTableViewCell {
            reviewCell.review = reviews[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedReview = reviews[indexPath.row]
        self.performSegue(withIdentifier: Storyboard.ShowReviewSegueIdentifier, sender: selectedReview)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ShowReviewSegueIdentifier {
            if let yourReviewVC = segue.destination as? YourReviewViewController {
                if let review = sender as? Review {
                    yourReviewVC.review = review
                }
            }
        }
    }

}
