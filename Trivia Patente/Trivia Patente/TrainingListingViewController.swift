//
//  TrainingListingViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class TrainingListingViewController: BaseViewController {

    @IBOutlet weak var newQuizButton: UIButton!
    
    @IBOutlet weak var proportionalBarContainer: UIView!
    @IBOutlet var bottomBarCostraint : [NSLayoutConstraint]!
    @IBOutlet var waveStatsLabel : [UILabel]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefaultBackgroundGradient()
        self.newQuizButton.mediumRounded()
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (t) in
            self.loadStats(values: [12, 2, 4, 10])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadStats(values: [UInt])
    {
        self.loadProportionalBar(values: values)
        self.loadExplicativeStats(values: values)
    }
    private func loadExplicativeStats(values: [UInt])
    {
        for i in 0..<self.bottomBarCostraint.count {
            self.waveStatsLabel[i].text = "\(values[i])"
        }
    }
    private func loadProportionalBar(values: [UInt])
    {
        let total = CGFloat(values.reduce(0, +))
        for c in 0..<self.bottomBarCostraint.count {
            print(CGFloat(values[c]) / total)
            self.bottomBarCostraint[c].constant = CGFloat(values[c]) / total * self.proportionalBarContainer.frame.width
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
