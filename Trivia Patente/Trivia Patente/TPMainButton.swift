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
