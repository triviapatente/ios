//
//  TPMainButton.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPMainButton: UIViewController {
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var titleView : UILabel!
    @IBOutlet var hintView : UILabel!
    
    var hints : [String] = []
    var currentHintIndex : Int!
    let HINT_CHANGE_DELAY : Double = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    var clickListener : ((TPMainButton) -> Void)!
    func initValues(imageName : String, title : String, color : UIColor, clickListener : @escaping (TPMainButton) -> Void) {
        self.imageView.image = UIImage(named: imageName)
        self.titleView.text = title
        self.view.backgroundColor = color
        self.clickListener = clickListener
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.mediumRounded()
    }
    func display(hint : String) {
        self.hintView.alpha = 0
        let oldOrigin = self.hintView.frame.origin.y
        self.hintView.frame.origin.y = -self.hintView.frame.size.height
        self.hintView.text = hint

        UIView.animate(withDuration: 0.5) {
            self.hintView.alpha = 1
            self.hintView.frame.origin.y = oldOrigin
        }
    }
    func display(hints : [String]) {
        self.hints = hints
        if let first = self.hints.first {
            self.display(hint: first)
            self.currentHintIndex = 1
            Timer.scheduledTimer(withTimeInterval: HINT_CHANGE_DELAY, repeats: true, block: changeHint)
        }
    
    }
    func changeHint(timer : Timer) {
        guard self.currentHintIndex < self.hints.count else {
            timer.invalidate()
            return
        }
        let newHint = self.hints[self.currentHintIndex]
        self.currentHintIndex = self.currentHintIndex + 1
        self.display(hint: newHint)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.clickListener(self)
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