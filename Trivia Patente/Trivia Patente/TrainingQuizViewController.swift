//
//  TrainingQuizViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 17/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
import SwiftyJSON

class TrainingQuizViewController: BasePlayViewController {

    var randomQuestions : Bool = true
    var training : Training! = Training()
    
    @IBOutlet weak var timerLabel : UILabel!
    @IBOutlet weak var completionCircularProgress : RPCircularProgress!
    
    let httpTraining = HTTPTraining()
    
    var trainingStartTime : TimeInterval? = nil
    let trainingDuration : TimeInterval = 40*60 // 40 minute
    var timer : Timer?
    
    override var mainOnDismiss: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pageControl.fullWidth = true
        self.getQuestions()
        
    }
    
    private func updateTrainingProgress() {
        let answered = self.training.questions!.filter { (q) -> Bool in
            return q.my_answer != nil
        }.count
        self.completionCircularProgress.updateProgress(CGFloat(answered)/CGFloat(training.questions!.count), animated: true, initialDelay: 0, duration: 0.1, completion: nil)

    }
    
    private func getQuestions(animated: Bool = true) {
        if animated {
            _ = MBProgressHUD.clearAndShow(to: self.view, animated: true)
        }
        httpTraining.get_new_training_questions(random: self.randomQuestions) { (response) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if response.success {
                self.training.questions = response.training!.questions!
                self.questions = response.training!.questions!
                self.startTimer()
            } else {
                self.handleGenericError(message: response.message, dismiss: true)
            }
        }
    }
    
    /* Timer handling */
    private func startTimer() {
        self.trainingStartTime = Date().timeIntervalSince1970
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            let elapsed = Date().timeIntervalSince1970 - self.trainingStartTime!
            let remaining = self.trainingDuration - elapsed
            self.timerLabel.text = String(format: "%02d:%02d", Int(remaining/60), Int(remaining.truncatingRemainder(dividingBy: 60.0)))
            if remaining <= 0 {
                self.timeFinished()
            }
        }
    }
    private func stopTimer() {
        if let t = timer {
            t.invalidate()
        }
    }
    private func timeFinished() {
        stopTimer()
    }
    
    override func user_answered(answer: Bool, correct: Bool, quiz: Quiz) {
        let index = self.questions.index(of: quiz)
        quiz.my_answer = answer
        quiz.answeredCorrectly = correct
        self.pageControl.reloadData()
        updateTrainingProgress()
        if let next = nextQuiz() {
            gotoQuiz(i: next)
        } else {
            self.trainingEnded()
        }
    }
    
    override func showImmediateResult() -> Bool {
        return false
    }
    
    override func trainMode() -> Bool {
        return true
    }
    
    func trainingEnded() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
