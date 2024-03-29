//
//  YourAnswersTableViewController.swift
//  PoligraphApp
//
//  Created by Gordon Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit

class YourAnswersTableViewController: UITableViewController {
    
    var questions = [Question]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
    
    private struct Storyboard {
        static let QuestionCellIdentifier = "Your Answer"
        static let ShowAnswerSegueIdentifier = "Show Answered Question"
        static let ShowUnansweredSegueIdentifier = "Show Unanswered Question"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let answeredQuestions = Question.loadAnsweredQuestions(forUser: (UIApplication.shared.delegate as! AppDelegate).currentUser!) {
            questions = answeredQuestions
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.QuestionCellIdentifier, for: indexPath)
        if let questionCell = cell as? YourAnswerTableViewCell {
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
