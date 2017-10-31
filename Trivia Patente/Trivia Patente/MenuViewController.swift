//
//  MenuViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 31/10/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.set(backgroundGradientColors: [Colors.primary.cgColor, Colors.secondary.cgColor])
        self.avatarImageView.circleRounded()
        
        // load data
        self.nameLabel.text = "Gabriel Ciulei"//SessionManager.currentUser!.fullName
        self.usernameLabel.text = SessionManager.currentUser!.username
        self.avatarImageView.load(user: SessionManager.currentUser!)
        // image size using button image insets in IB
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
