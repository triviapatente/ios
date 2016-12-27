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
    
    
    var topView : UIView {
        return self.topViewController!.view
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        avatarItem = AvatarButtonItem(user: SessionManager.currentUser, callback: {
            self.goTo(AlphaViewController.self, identifier: "alpha_segue")
        })
        menuItem = MenuButtonItem(callback: { action in
            switch(action) {
                case .profile: self.goTo(AlphaViewController.self, identifier: "alpha_segue")
                               break
                case .settings: self.goTo(SettingsViewController.self, identifier: "settings_segue")
                                break
                case .credits: self.goTo(AlphaViewController.self, identifier: "alpha_segue")
                               break
                case .logout: self.topView.fade()
                              self.goTo(LogoutViewController.self, identifier: "logout_segue")
                              break
            }
        }, sender: self)
        lifesItem = LifesButtonItem(callback: {
            self.goTo(AlphaViewController.self, identifier: "alpha_segue")
        })
        //TODO: edit with correct informations
        lifesItem.numberOfLifes = 5
    }
    func setUser(candidate : User?, with_title : Bool = true) {
        if let user = candidate {
            if with_title {
                self.topViewController?.title = user.username
            }
            self.avatarItem.user = candidate
        }
    }
    func goTo(_ vcClass : UIViewController.Type, identifier : String) {
        if let controller = self.topViewController {
            guard type(of: controller) != vcClass else {
                return
            }
        }
        self.performSegue(withIdentifier: identifier, sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.configureBar()
    }
    func configureBar() {
        if let navigationItem = self.topViewController?.navigationItem {
            let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            negativeSpacer.width = -20
            navigationItem.rightBarButtonItems = [negativeSpacer, menuItem, avatarItem]
            if self.viewControllers.count == 1 {
                navigationItem.leftBarButtonItems = [negativeSpacer, lifesItem]
            }
        }
        
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        self.configureBar()
    }
    override func popViewController(animated: Bool) -> UIViewController? {
        if let controller = self.topViewController as? TPGameViewController {
            if controller.mainOnDismiss {
                let lastIndex = self.viewControllers.index(of: controller)!
                let firstIndex = self.viewControllers.index(where: {$0 is MainViewController})! + 1
                self.viewControllers.removeSubrange(firstIndex..<lastIndex)
            }
        }
        return super.popViewController(animated: animated)
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
