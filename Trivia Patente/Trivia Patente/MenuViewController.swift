//
//  MenuViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 31/10/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    static let kMenuActionLogout = "logoutMenuAction"
    static let kMenuActionProfile = "profileMenuAction"
    static let kMenuActionContact = "contactMenuAction"

    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var actionCallback : ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefaultBackgroundGradient()
        self.avatarImageView.circleRounded()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // load user data
        self.nameLabel.text = SessionManager.currentUser!.fullName
        self.usernameLabel.text = SessionManager.currentUser!.username
        self.avatarImageView.load(user: SessionManager.currentUser!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profile()
    {
        self.sendAction(action: MenuViewController.kMenuActionProfile)
    }
    
    @IBAction func infos()
    {
        self.sendAction(action: MenuViewController.kMenuActionContact)
    }
    
    func sendAction(action: String)
    {
        self.dismiss(animated: true, completion: nil)
        if let cb = self.actionCallback
        {
            cb(action)
        }
    }
    
    @IBAction func logout()
    {
        self.performSegue(withIdentifier: "logout_segue", sender: nil)
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