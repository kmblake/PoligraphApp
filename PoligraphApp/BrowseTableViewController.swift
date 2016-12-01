//
//  BrowseTableViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/30/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class BrowseTableViewController: UITableViewController, UISearchBarDelegate {

    let questionSearchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Search Results") as UIViewController)
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
    
    var askToolbar: UIToolbar? {
        didSet {
            questionSearchController.searchBar.inputAccessoryView = askToolbar
            questionSearchController.searchBar.reloadInputViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionSearchController.searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: Notification.Name.UIKeyboardDidHide, object: nil)
        
        questionSearchController.hidesNavigationBarDuringPresentation = false
        questionSearchController.dimsBackgroundDuringPresentation = true
        if let searchResultsTVC = questionSearchController.searchResultsController as? SearchResultsTableViewController {
            questionSearchController.searchResultsUpdater = searchResultsTVC
        }
        definesPresentationContext = true
        
        
        
        if let newQuestions = Question.loadQuestions(withStatus: Question.StatusTypes.reviewed, inManagedObjectContext: moc) {
            questions = newQuestions
            print("Questions Loaded")
            print("Number of results: \(questions.count)")
        } else {
            print("Question load failed.")
        }
        askToolbar = makeToolbar(prompt: "Don't see your question?", buttonText: "Ask", selector: #selector(askPressed))
        
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
        static let BrowseQuestionCellIdentifier = "Question"
        static let RowHeight: CGFloat = 250.0 //TODO: Autoset?
        static let ShowAnsweredQuestionSegue = "Show Answer"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.BrowseQuestionCellIdentifier, for: indexPath)
        let question = questions[indexPath.row]
        if let questionCell = cell as? BrowseQuestionTableViewCell {
            questionCell.question = question
        }
        //TODO: Return inside or outside?
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Storyboard.RowHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return questionSearchController.searchBar.bounds.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return questionSearchController.searchBar
    }
    
    // Mark: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(!searchText.isEmpty) {
            if let askButton = askToolbar?.items?[2] {
                askButton.isEnabled = true
                askToolbar?.reloadInputViews()
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ShowAnsweredQuestionSegue {
            if let answeredQuestionVC = segue.destination as? AnsweredQuestionViewController {
                if let question = (sender as? BrowseQuestionTableViewCell)?.question {
                    answeredQuestionVC.question = question
                }
            }
        }
    }

}
