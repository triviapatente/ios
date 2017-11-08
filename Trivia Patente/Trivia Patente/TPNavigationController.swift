//
//  TPNavigationController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SideMenu


class TPNavigationController: UINavigationController {
    
//    var avatarItem: AvatarButtonItem!
    var menuItem: UIBarButtonItem!
//    var lifesItem: LifesButtonItem! // non funzionava niente!! Perso ore e ore
    var lifesItem : UIBarButtonItem!
    
    var topView : UIView {
        return self.topViewController!.view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewDidLoad() {
        SideMenuManager.menuFadeStatusBar = false
        // 240 grandezza minima, 300 grandezza massima
        SideMenuManager.menuWidth = min(max(UIScreen.main.bounds.width * 0.80, 240), 300)
        
        // download user data so that the app has a new copy of them
        HTTPAuth().user { response in
            if let currentUser = response.user {
                SessionManager.set(user: currentUser)
                UIImage.downloadImage(url: currentUser.avatarImageUrl!, callback: { image in
                    let u = SessionManager.currentUser! // need to create a copy to update values and the copy needs to be done inside the callback
                    u.savedImaged = image
                    SessionManager.set(user: u)
                })
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        avatarItem = AvatarButtonItem(user: SessionManager.currentUser, callback: {
//            self.goTo(AlphaViewController.self, identifier: "alpha_segue")
//        })
        
        menuItem = UIBarButtonItem(image: UIImage(named: "menu-hamburger"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMenu))
        
        // TODO: make this better - temporary solution
        let heartImageView = UIImageView(image: UIImage(named: "heart-infinity"))
        heartImageView.isUserInteractionEnabled = true
        let tapper = UITapGestureRecognizer(target: self, action: #selector(lifesPressed))
        heartImageView.addGestureRecognizer(tapper)
        lifesItem = UIBarButtonItem(customView: heartImageView)
        
        //TODO: edit with correct informations
//        lifesItem.numberOfLifes = 5
    }
    
    func showMenu()
    {
        self.popToRootViewController(animated: true)
        performSegue(withIdentifier: "menu_segue", sender: nil)
    }
    
    func handleRandomLuckyPopoverShow()
    {
        /* HOW IT WORKS
         *
         * First of all check if the user has chosen not to see the popover again
         *
         * Get the date for when it has been shown the last time anche check if there is at least 1 day of difference
         * If YES, then show the lucky popover and save the new date
         * ELSE do nothing
         *
         * If there is no date at all for the last time it has been shown then it might mean that it is the first time the user has opened the app
         * so just save the current date as last date it is has been show (but don't show it)
         *
         * This date is saved inside NSUSerDefaults as TIMESTAMP
         */
        if let shouldShowPop = UserDefaults.standard.value(forKey: Constants.kLuckyPopShouldShowTS) as? Bool
        {
            if shouldShowPop == false
            {
                return
            }
        }
        
        let minTimeDifference = Double(60*60*24) // 1 day in seconds
        let currentTS = NSDate().timeIntervalSince1970
        if let lastDateTS = UserDefaults.standard.value(forKey: Constants.kLastLuckyPopTS) as? TimeInterval
        {
            if currentTS - lastDateTS >= minTimeDifference
            {
                // show popover
                self.setDateForLastLuckyPop(lastTS: currentTS)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (t) in
                    DispatchQueue.main.async {
                        self.showLuckyPopover(automatic: true)
                    }
                })
            }
        } else
        {
            self.setDateForLastLuckyPop(lastTS: currentTS)
        }
    }
    
    func setDateForLastLuckyPop(lastTS : TimeInterval)
    {
        UserDefaults.standard.set(lastTS, forKey: Constants.kLastLuckyPopTS)
    }
    
    func lifesPressed()
    {
        self.showLuckyPopover()
    }
    
    func showLuckyPopover(automatic: Bool = false)
    {
        self.automaticTriggerForLuckyPop = automatic
        self.goTo(LuckyModalViewController.self, identifier: "lucky_segue")
    }
    
    func setUser(candidate : User?, with_title : Bool = true) {
        if let user = candidate {
            if with_title {
                self.topViewController?.title = user.displayName
            }
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
        self.handleRandomLuckyPopoverShow()
    }
    
    func configureBar() {
        if let topController = self.topViewController as? MainViewController
        {
            let navigationItem = topController.navigationItem
            if self.viewControllers.count == 1 {
                navigationItem.leftBarButtonItems = [menuItem]
            }
            if topController.needsMenu() {
                navigationItem.rightBarButtonItems = [lifesItem]
            } else {
//                navigationItem.rightBarButtonItems = [avatarItem]
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
        // Dispose of any resources that can be recreated
    }
    
    // MARK: - Navigation

    var automaticTriggerForLuckyPop = true // wheater the lucky popover is show automatically. It is necessary to differentiate between automatic and manual so that different configurations can be done
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueId = segue.identifier
        {
            switch segueId {
            case "lucky_segue":
                if automaticTriggerForLuckyPop
                {
                    (segue.destination as! LuckyModalViewController).shouldShowDoNotShow = true
                }
                break
            case "menu_segue":
                let menuController = (segue.destination as! UISideMenuNavigationController).topViewController! as! MenuViewController
                menuController.actionCallback = {(action) in
                    switch action {
                    case MenuViewController.kMenuActionContact:
                        self.goTo(AlphaViewController.self, identifier: "contact_segue")
                        break
                    case MenuViewController.kMenuActionProfile:
                        self.goTo(AccountViewController.self, identifier: "account_segue")
                        break
                    case MenuViewController.kMenuActionLogout:
                        self.performSegue(withIdentifier: "logout_segue", sender: nil)
//                        self.goTo(LogoutViewController.self, identifier: "logout_segue")
                        break
                    default:
                        break
                    }
                }
                break
            default:
                break;
            }
        }
        
    }
    

}
