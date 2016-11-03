//
//  TPNavigationController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPNavigationController: UINavigationController {
    var avatarItem: AvatarButtonItem!
    var menuItem: MenuButtonItem!
    var lifesItem: LifesButtonItem!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        avatarItem = AvatarButtonItem(user: SessionManager.currentUser, callback: {
            self.goTo(identifier: "profile_segue")
        })
        menuItem = MenuButtonItem(callback: { action in
            switch(action) {
                case .profile: self.goTo(identifier: "profile_segue")
                               break
                case .settings: self.goTo(identifier: "settings_segue")
                                break
                case .credits: self.goTo(identifier: "credits_segue")
                               break
                case .logout: SessionManager.logout()
                              break
            }
        }, sender: self)
        lifesItem = LifesButtonItem()
    }
    func goTo(identifier : String) {
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.configureBar()
    }
    func configureBar() {
        if let controller = self.topViewController {
            controller.navigationItem.rightBarButtonItems = [menuItem, avatarItem]
            controller.navigationItem.leftBarButtonItem = lifesItem
        }
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        self.configureBar()
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
