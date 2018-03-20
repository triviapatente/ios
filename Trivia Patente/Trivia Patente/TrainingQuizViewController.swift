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
import BulletinBoard

class TrainingQuizViewController: BasePlayViewController {

    var randomQuestions : Bool = true
    var training : Training! = Training()
    
    @IBOutlet weak var timerLabel : UILabel!
    @IBOutlet weak var completionCircularProgress : RPCircularProgress!
    @IBOutlet weak var exitButton: UIButton!
    
    let httpTraining = HTTPTraining()
    
    var trainingStartTime : TimeInterval? = nil
    let trainingDuration : TimeInterval = 2*60 // 40 minute
    var elapsedTime : TimeInterval = 0
    var timer : Timer?
    
    override var mainOnDismiss: Bool {
        return false
    }
    
    var numberOfAnsweredItems : Int {
        guard self.training.questions != nil else { return 0 }
        return self.training.questions!.filter { (q) -> Bool in
            return q.my_answer != nil
            }.count
    }
    
    lazy var bulletinManager: BulletinManager = {
        let page = PageBulletinItem(title: "Tempo scaduto")
        page.interfaceFactory.tintColor = Colors.primary
        //        factory.alternativeButtonColor = Colors.secondary
        page.interfaceFactory.actionButtonTitleColor = .white
        page.shouldCompactDescriptionText = true
        
        page.image = UIImage(named: "timer-icon-dark")
        
        let answered = self.numberOfAnsweredItems
        page.descriptionText = "Il tempo a tua disposizione per completare il questionario è finito. " + (answered < 40 ? "Hai risposto a \(answered) \((answered==1 ? "domanda." : "domande."))." : "Hai risposto a tutte le domande.")
        page.actionButtonTitle = "Concludi questionario"
        page.alternativeButtonTitle = "Cancella"
        
        page.actionHandler = { (item: PageBulletinItem) in
            self.closeTraining(save: true, manager: self.bulletinManager)
        }
        
        page.alternativeHandler = { (item: PageBulletinItem) in
            self.closeTraining(save: false, manager: self.bulletinManager)
        }
        
        return BulletinManager(rootItem: page)
        
    }()
    
    lazy var bulletinEndTraining: BulletinManager = {
        let page = PageBulletinItem(title: "Concludi allenamento")
        page.interfaceFactory.tintColor = Colors.primary
        page.interfaceFactory.actionButtonTitleColor = .white
        page.isDismissable = true
        page.shouldCompactDescriptionText = true
        
        let answered = self.numberOfAnsweredItems
        page.descriptionText = "Sei sicuro di voler uscire dall'allenamento? " + (answered < 40 ? "Hai risposto a \(answered) \((answered==1 ? "domanda." : "domande."))" : "Hai risposto a tutte le domande.")
        page.actionButtonTitle = "Esci e salva"
        page.alternativeButtonTitle = "Esci e annulla"
        
        page.actionHandler = { (item: PageBulletinItem) in
//            self.bulletinEndTraining.rootItem.isDismissable = false
            self.closeTraining(save: true, manager: self.bulletinEndTraining)
        }
        
        page.alternativeHandler = { (item: PageBulletinItem) in
            self.closeTraining(save: false, manager: self.bulletinEndTraining)
        }
        
        return BulletinManager(rootItem: page)
        
    }()
    
    lazy var bulletinTrainingDone: BulletinManager = {
        let page = PageBulletinItem(title: "Allenamento completato")
        page.interfaceFactory.tintColor = Colors.primary
        page.interfaceFactory.actionButtonTitleColor = .white
        page.image = UIImage(named: "completed-icon")
        
        let answered = self.numberOfAnsweredItems
        page.descriptionText = "Hai risposto a tutte le domande dell'allenamento 👏"
        page.actionButtonTitle = "Vedi i risultati"
        page.alternativeButtonTitle = "Rivedi le domande"
        
        page.actionHandler = { (item: PageBulletinItem) in
            self.closeTraining(save: true, manager: self.bulletinTrainingDone)
        }
        
        page.alternativeHandler = { (item: PageBulletinItem) in
            self.bulletinTrainingDone.dismissBulletin(animated: true)
        }
        
        return BulletinManager(rootItem: page)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        exitButton.circleRounded()
        exitButton.darkerBorder(of: 0.10, width: 5)
        self.pageControl.fullWidth = true
        self.pageControl.numberTitleOffset = 1
        self.getQuestions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appChangedStatusToInactive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appChangedStatusToActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

    }
    
    @IBAction func userWantsToExit() {
        self.bulletinEndTraining.prepare()
        self.bulletinEndTraining.presentBulletin(above: self)
    }
    
    @objc private func appChangedStatusToActive() {
        self.restartTimer()
    }
    @objc private func appChangedStatusToInactive() {
        self.stopTimer()
    }
    
    func closeTraining(save: Bool, manager: BulletinManager) {
        if save {
            manager.displayActivityIndicator()
        } else {
            manager.dismissBulletin(animated: true)
            self.exitPlaying()
        }
        
    }
    private func updateTrainingProgress() {
        self.completionCircularProgress.updateProgress(CGFloat(numberOfAnsweredItems)/CGFloat(training.questions!.count), animated: true, initialDelay: 0, duration: 0.1, completion: nil)
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
                self.initiateTimer()
            } else {
                self.handleGenericError(message: response.message, dismiss: true)
            }
        }
    }
    
    /* Timer handling */
    private func initiateTimer() {
        self.trainingStartTime = Date().timeIntervalSince1970
        self.startTimer()
    }
    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
            self.elapsedTime = Date().timeIntervalSince1970 - self.trainingStartTime!
            let remaining = self.trainingDuration - self.elapsedTime
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
        showTimeOut()
    }
    private func restartTimer() {
        self.trainingStartTime = Date().timeIntervalSince1970 - self.elapsedTime
        self.startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopTimer()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    private func showTimeOut() {
        self.bulletinManager.prepare()
        self.bulletinManager.presentBulletin(above: self)
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
        self.bulletinTrainingDone.prepare()
        self.bulletinTrainingDone.presentBulletin(above: self)
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
