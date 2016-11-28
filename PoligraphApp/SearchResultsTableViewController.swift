//
//  SearchResultsTableViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/22/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating  {
    
    
    private struct Storyboard {
        static let SearchCellIdentifier = "Search"
        static let ShowAnswerSegueIdentifier = "Show Answer"
    }
    
    var questions: [Question]? {
        didSet {
            print("Search questions set: \(questions!.count)")
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let questionsArray = questions {
            return questionsArray.count
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.SearchCellIdentifier, for: indexPath)
        let question = questions![indexPath.row]
        
        if let questionCell = cell as? SearchTableViewCell {
            questionCell.question = question
        }
    
        return cell
    }
    
    // MARK: Search controller implementation
    
    func updateSearchResults(for searchController: UISearchController) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
        //TODO: all questions or reviewed questions?
        let questions = Question.searchQuestions(withStatus: nil, text: searchController.searchBar.text!, inManagedObjectContext: moc)
        if let searchResultsTVC = searchController.searchResultsController as? SearchResultsTableViewController {
            searchResultsTVC.questions = questions
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier! == Storyboard.ShowAnswerSegueIdentifier {
            if let answeredQuestionVC = segue.destination as? AnsweredQuestionViewController {
                if let question = (sender as? SearchTableViewCell)?.question {
                    print("Segueing to Answered Question VC from Search")
                    answeredQuestionVC.question = question
                }
            }
        }
    }

}
