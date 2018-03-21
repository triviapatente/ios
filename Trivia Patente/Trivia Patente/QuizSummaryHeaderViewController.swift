//
//  QuizSummaryHeaderViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 09/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

protocol QuizSummaryHeaderViewDelegate {
    var item : Training? { get }
}

class QuizSummaryHeaderViewController: UIViewController {
    @IBOutlet weak var scoreButton: QuizScoreButton!
    @IBOutlet weak var mainLabel: UILabel!
    
    var delegate : QuizSummaryHeaderViewDelegate? {
        didSet {
            self.refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.refresh()
    }
    
    func refresh() {
        if let d = self.delegate {
            self.setItem(item: d.item)
        }
    }
    
    func setItem(item: Training?) {
        if let training = item {
            scoreButton.setScore(scoreNumber: training.numberOfErrors)
            mainLabel.text = "In questo questionario hai fatto \(training.numberOfErrors!) errori\nCompletato: \(training.createdAt!.prettyDate.lowercased())"
        }
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
