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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        if let unansweredQuestions = Question.loadQuestions(withStatus: Question.StatusTypes.asked, inManagedObjectContext: moc) {
            questions = unansweredQuestions
        }
        
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
