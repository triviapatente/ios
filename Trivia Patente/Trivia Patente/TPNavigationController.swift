//
//  TPNavigationController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit



class TPNavigationController: UINavigationController {
    
//    var avatarItem: AvatarButtonItem!
    var menuItem: MenuButtonItem!
//    var lifesItem: LifesButtonItem! // non funzionava niente!! Perso ore e ore
    var lifesItem : UIBarButtonItem!
    
    var topView : UIView {
        return self.topViewController!.view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewDidLoad() {
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        avatarItem = AvatarButtonItem(user: SessionManager.currentUser, callback: {
//            self.goTo(AlphaViewController.self, identifier: "alpha_segue")
//        })
        menuItem = MenuButtonItem(callback: { action in
            switch(action) {
                case .profile: self.goTo(AlphaViewController.self, identifier: "alpha_segue")
                               break
                case .settings: self.goTo(AlphaViewController.self, identifier: "alpha_segue")
                                break
                case .credits: self.goTo(AlphaViewController.self, identifier: "alpha_segue")
                               break
                case .logout: self.topView.fade()
                              self.goTo(LogoutViewController.self, identifier: "logout_segue")
                              break
            }
        }, sender: self)
        
        // TODO: make this better - temporary solution
        let heartImageView = UIImageView(image: UIImage(named: "heart-infinity"))
        heartImageView.isUserInteractionEnabled = true
        let tapper = UITapGestureRecognizer(target: self, action: #selector(lifesPressed))
        heartImageView.addGestureRecognizer(tapper)
        lifesItem = UIBarButtonItem(customView: heartImageView)
        
        //TODO: edit with correct informations
//        lifesItem.numberOfLifes = 5
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
        
        let minTimeDifference = Double(0) // Double(60*60*24) // 1 day in seconds
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
//            self.avatarItem.user = candidate
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
        if let topController = self.topViewController {
            let navigationItem = topController.navigationItem
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = -20
            if self.viewControllers.count == 1 {
                navigationItem.leftBarButtonItems = [spacer, menuItem]
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
        // Dispose of any resources that can be recreated.
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
                break;
            default:
                break;
            }
        }
        
    }
    

}
