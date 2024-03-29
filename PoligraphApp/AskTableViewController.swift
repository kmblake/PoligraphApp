//
//  AskTableViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/30/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class AskTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {

    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionSearchController.searchBar.delegate = self
        questionSearchController.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        questionSearchController.hidesNavigationBarDuringPresentation = false
        questionSearchController.dimsBackgroundDuringPresentation = true
        if let searchResultsTVC = questionSearchController.searchResultsController as? SearchResultsTableViewController {
            questionSearchController.searchResultsUpdater = searchResultsTVC
        }
        definesPresentationContext = true

        tableView.tableHeaderView = questionSearchController.searchBar
        
        if let userQuestions = Question.loadUnansweredQuestions(forUser: (UIApplication.shared.delegate as! AppDelegate).currentUser!) {
            questions = userQuestions
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    // MARK: UI Search Controller Delegate
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - UI Search Bar Delegate
    
    let questionSearchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Search Results") as UIViewController)
    
    var askToolbar: UIToolbar? {
        didSet {
            questionSearchController.searchBar.inputAccessoryView = askToolbar
            questionSearchController.searchBar.reloadInputViews()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let askButton = askToolbar?.items?[2] {
            if(!searchText.isEmpty) {
                askButton.isEnabled = true
                if let searchResultsTVC = questionSearchController.searchResultsUpdater as? SearchResultsTableViewController {
                    if let questionsArray = searchResultsTVC.questions {
                        if questionsArray.count > 0 {
                            if(searchText.caseInsensitiveCompare(questionsArray[0].text!) == ComparisonResult.orderedSame) {
                                askButton.isEnabled = false
                            } else {
                                askButton.isEnabled = true
                            }
                        }
                    }
                }
            } else {
                askButton.isEnabled = false
            }
            askToolbar?.reloadInputViews()
        }
    }
    
    // MARK: - Ask Toolbar Management
    
    func makeToolbar(prompt: String, buttonText: String, selector: Selector) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let prompt = UIBarButtonItem(title: prompt, style: .plain, target: self, action: nil)
        prompt.isEnabled = false
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let button = UIBarButtonItem(title: buttonText, style: .plain, target: self, action: selector)
        if(buttonText != "Submit") {
            button.isEnabled = false
        }
        toolBar.setItems([prompt, spaceButton, button], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        return toolBar
    }
    
    func askPressed() {
        askToolbar = makeToolbar(prompt: "Check your question", buttonText: "Submit", selector: #selector(submitPressed))
        if let searchResultsController = questionSearchController.searchResultsController as? SearchResultsTableViewController {
            searchResultsController.askPressed = true
            searchResultsController.tableView.tableFooterView = UIView() // Gets rid of ghost cells
            searchResultsController.tableView.reloadData()
        }
        
    }
    
    func submitPressed() {
        if let questionText = questionSearchController.searchBar.text {
            if let user = User.currentUser(inManagedObjectContext: moc)  {
                _ = Question.addAskedQuestion(asker: user, text: questionText, inManagedObjectContext: moc)
            }
        }
        if let searchResultsController = questionSearchController.searchResultsController as? SearchResultsTableViewController {
            searchResultsController.performSegue(withIdentifier: Storyboard.AskTabSegueIdentifier, sender: searchResultsController)
        }
        
    }
    
    func keyboardDidHide() {
        askToolbar = makeToolbar(prompt: "Don't see your question?", buttonText: "Ask", selector: #selector(askPressed))
        if let searchResultsController = questionSearchController.searchResultsController as? SearchResultsTableViewController {
            searchResultsController.askPressed = false
        }
    }


    // MARK: - Table view data source
    
    private struct Storyboard {
        static let QuestionCellIdentifier = "Your Question"
        static let ShowAnswerSegueIdentifier = "Show Answered Question"
        static let ShowUnansweredSegueIdentifier = "Show Unanswered Question"
        static let AskTabSegueIdentifier = "Return to Ask"
    }

    var questions = [Question]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.QuestionCellIdentifier, for: indexPath)
        if let questionCell = cell as? YourQuestionsTableViewCell {
            questionCell.question = questions[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedQuestion = questions[indexPath.row]
        if selectedQuestion.status == Int32(Question.StatusTypes.reviewed.rawValue) {
            self.performSegue(withIdentifier: Storyboard.ShowAnswerSegueIdentifier, sender: selectedQuestion)
        } else {
            self.performSegue(withIdentifier: Storyboard.ShowUnansweredSegueIdentifier, sender: selectedQuestion)
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
        }
    }

}
