//
//  AnswerViewController.swift
//  PoligraphApp
//
//  Created by Kent Blake on 12/2/16.
//  Copyright © 2016 Silo Busters. All rights reserved.
//

import UIKit
import Koloda

class AnswerViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {
    
    @IBOutlet var kolodaView: KolodaView!
    
    var questions = [Question]() {
        didSet {
            kolodaView.reloadData()
        }
    }
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).dataStack.mainContext
    
    private struct Storyboard {
        static let ShowAnswersSegue = "Show Your Answers"
        static let ChooseQuestionSegueIdentifier = "Choose Question"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        if let unansweredQuestions = Question.loadQuestions(
            withStatus: Question.StatusTypes.asked,
            excludingUser: (UIApplication.shared.delegate as! AppDelegate).currentUser!,
            inManagedObjectContext: moc) {
            questions = unansweredQuestions
        }

    }
    
    // MARK: Koloda View Delegate implementation
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //TODO implement
    }
    
    // MARK: Koloda View Data Source implementation
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return questions.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        //let questionFrame = CGRect(x: 0.0, y: 0.0, width: koloda.bounds.width * 0.8, height: koloda.bounds.height)
        return QuestionCardView(frame: koloda.bounds, question: questions[index])
    }
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)![0] as? OverlayView
//    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.ChooseQuestionSegueIdentifier {
            if let writeAnswerVC = segue.destination as? WriteAnswerViewController {
                let question = questions[kolodaView.currentCardIndex]
                writeAnswerVC.question = question
            }
        }
    }

}
