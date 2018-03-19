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
    
    let httpTraining = HTTPTraining()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getQuestions()
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
            } else {
                self.handleGenericError(message: response.message, dismiss: true)
            }
        }
    }
    
    override func user_answered(answer: Bool, correct: Bool, quiz: Quiz) {
        let index = self.questions.index(of: quiz)
        quiz.my_answer = answer
        quiz.answeredCorrectly = correct
        self.pageControl.reloadData()
        if let next = nextQuiz() {
            gotoQuiz(i: next)
        } else {
            self.trainingEnded()
        }
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
