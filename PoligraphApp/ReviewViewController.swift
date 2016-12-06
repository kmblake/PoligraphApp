//
//  ReviewViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 11/13/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit
import Koloda

class ReviewViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {

    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBAction func nextButton(_ sender: UIButton) {
        kolodaView.swipe(.left)
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        kolodaView.swipe(.right)
    }
    
    @IBAction func undoButton(_ sender: UIBarButtonItem) {
        kolodaView.revertAction()
    }
    
    var questions = [Question]() {
        didSet {
            kolodaView.reloadData()
        }
    }
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext

    private struct Storyboard {
        static let ChooseAnswerSegueIdentifier = "Choose Answer"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self

        if let unreviewedQuestions = Question.loadQuestions(
            withStatus: Question.StatusTypes.answered,
            excludingUser: (UIApplication.shared.delegate as! AppDelegate).currentUser!,
            inManagedObjectContext: moc) {
            print("Loaded \(unreviewedQuestions.count) unreviewed questions")
            questions = unreviewedQuestions
        }
    }
    
    // MARK: Koloda View Delegate implementation
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            self.performSegue(withIdentifier: Storyboard.ChooseAnswerSegueIdentifier, sender: questions[index])
        }
    }
    
    // MARK: Koloda View Data Source implementation
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return questions.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return QuestionCardView(frame: koloda.bounds, question: questions[index], answer: false)
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ChooseAnswerSegueIdentifier {
            if let writeReviewVC = segue.destination as? WriteReviewViewController {
                if let question = sender as? Question {
                    writeReviewVC.question = question
                }
            }
        }
    }

}
