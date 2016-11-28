//
//  FirstViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/13/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //let searchResultsController = SearchResultsTableViewController()

    let questionSearchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Search Results") as UIViewController)
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        questionSearchController.dimsBackgroundDuringPresentation = true
        if let searchResultsTVC = questionSearchController.searchResultsController as? SearchResultsTableViewController {
            questionSearchController.searchResultsUpdater = searchResultsTVC
        }
        tableView.tableHeaderView = questionSearchController.searchBar
        definesPresentationContext = true
        
        if let newQuestions = Question.loadQuestions(withStatus: Question.StatusTypes.reviewed, inManagedObjectContext: moc) {
            questions = newQuestions
            print("Questions Loaded")
            print("Number of results: \(questions.count)")
            //print("\(questions[0].text)")
        } else {
            print("Question load failed.")
        }
        
        
    }
    
    // MARK: - Table view data source
    
    private struct Storyboard {
        static let BrowseQuestionCellIdentifier = "Question"
        static let RowHeight: CGFloat = 250.0
        static let ShowAnsweredQuestionSegue = "Show Answer"
    }
    
    var questions = [Question]() {
        didSet {
            print("Set questions")
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    func numberOfSections(in tableView: UITableView) -> Int {
        print("Loading Sections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Getting row numbers")
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.BrowseQuestionCellIdentifier, for: indexPath)
        let question = questions[indexPath.row]
        
        print("Getting cell")
        if let questionCell = cell as? BrowseQuestionTableViewCell {
            questionCell.question = question
            print("Assigned question")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Storyboard.RowHeight
    }
    
     // MARK: - Navigation
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ShowAnsweredQuestionSegue {
            if let answeredQuestionVC = segue.destination as? AnsweredQuestionViewController {
                if let question = (sender as? BrowseQuestionTableViewCell)?.question {
                    print("Segueing to Answered Question VC")
                    answeredQuestionVC.question = question
                }
            }
        }
     }


}

