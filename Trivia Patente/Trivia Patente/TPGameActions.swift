//
//  TPQuizActions.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPGameActions: UIViewController {

    
    @IBOutlet var chatButton : UIButton!
    @IBOutlet var leaveButton : UIButton!
    @IBOutlet var detailButton : UIButton!
    
    @IBAction func goToDetail() {
        
    }
    @IBAction func leaveGame() {
        
    }
    @IBAction func goToChat() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatButton.circleRounded()
        chatButton.darkerBorder(of: 0.10, width: 5)
        leaveButton.circleRounded()
        leaveButton.darkerBorder(of: 0.10, width: 5)
        detailButton.circleRounded()
        detailButton.darkerBorder(of: 0.10, width: 5)

        // Do any additional setup after loading the view.
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
