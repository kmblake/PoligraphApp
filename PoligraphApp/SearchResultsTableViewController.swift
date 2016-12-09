//
//  SearchResultsTableViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/22/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController, UISearchResultsUpdating  {
    
    var askPressed = false
    
    private struct Storyboard {
        static let SearchCellIdentifier = "Search"
        static let ShowAnswerSegueIdentifier = "Show Answered Question"
        static let ShowUnansweredSegueIdentifier = "Show Unanswered Question"
        static let CheckCellIdentifier = "Submit Check"
        static let AskTabSegueIdentifier = "Return to Ask"
    }
    
    var questions: [Question]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if askPressed {
            return 1
        } else if let questionsArray = questions {
            return questionsArray.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if askPressed {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CheckCellIdentifier, for: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.SearchCellIdentifier, for: indexPath)
            let question = questions![indexPath.row]
            
            if let questionCell = cell as? SearchTableViewCell {
                questionCell.question = question
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedQuestion = questions?[indexPath.row] {
            if selectedQuestion.status == Int32(Question.StatusTypes.reviewed.rawValue) {
                self.performSegue(withIdentifier: Storyboard.ShowAnswerSegueIdentifier, sender: selectedQuestion)
            } else {
                self.performSegue(withIdentifier: Storyboard.ShowUnansweredSegueIdentifier, sender: selectedQuestion)
            }
        }
    }
    
    // MARK: Search controller implementation
    
    func updateSearchResults(for searchController: UISearchController) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
        let questions = Question.searchQuestions(withStatus: nil, text: searchController.searchBar.text!, inManagedObjectContext: moc)
        if let searchResultsTVC = searchController.searchResultsController as? SearchResultsTableViewController {
            searchResultsTVC.questions = questions
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ShowAnswerSegueIdentifier {
            if let answeredQuestionVC = segue.destination as? AnsweredQuestionViewController {
                if let question = sender as? Question {
                    answeredQuestionVC.question = question
                }
            }
        } else if segue.identifier! == Storyboard.ShowUnansweredSegueIdentifier {
            if let unansweredQuestionVC = segue.destination as? UnansweredQuestionViewController {
                if let question = sender as? Question {
                    unansweredQuestionVC.question = question
                }
            }
        } else if segue.identifier! == Storyboard.AskTabSegueIdentifier {
            if let tabBarController = segue.destination as? UITabBarController {
                tabBarController.selectedIndex = 1
            }
        }
    }

}
