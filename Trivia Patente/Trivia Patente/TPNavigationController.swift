//
//  TPNavigationController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 26/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import SideMenu

enum PopoverType {
    case lucky
    case review
    case privacyUpdate, termsUpdate
    
    var shouldShow : Bool? {
        switch self {
            case .lucky:
                return UserDefaults.standard.value(forKey: Constants.kLuckyPopShouldShowTS) as? Bool
            case .review:
                return UserDefaults.standard.value(forKey: Constants.kReviewPopShouldShowTS) as? Bool
            default:
                return false
        }
    }
    
    var lastTS : TimeInterval? {
        switch self {
            case .lucky:
                return UserDefaults.standard.value(forKey: Constants.kLastLuckyPopTS) as? TimeInterval
            case .review:
                return UserDefaults.standard.value(forKey: Constants.kLastReviewPopTS) as? TimeInterval
            case .privacyUpdate:
                return UserDefaults.standard.value(forKey: Constants.kLastPrivacyPopTS) as? TimeInterval
            case .termsUpdate:
                return UserDefaults.standard.value(forKey: Constants.kLastTermsPopTS) as? TimeInterval
        }
    }
    
    var minDifference : Double {
        switch self {
            case .lucky:
                return Double(60*60*24*13) // 13 days
            case .review:
                return Double(60*60*24*17) // 17 days
            default:
                return 0.0
        }
    }
    
    func setLastDate(lastTS: TimeInterval) {
        switch self {
            case .lucky:
                return UserDefaults.standard.set(lastTS, forKey: Constants.kLastLuckyPopTS)
            case .review:
                return UserDefaults.standard.set(lastTS, forKey: Constants.kLastReviewPopTS)
            case .privacyUpdate:
                return UserDefaults.standard.set(lastTS, forKey: Constants.kLastPrivacyPopTS)
            case .termsUpdate:
                return UserDefaults.standard.set(lastTS, forKey: Constants.kLastTermsPopTS)
        }
    }
    
    func setShoudShow(show: Bool) {
        switch self {
            case .lucky:
                return UserDefaults.standard.set(show, forKey: Constants.kLuckyPopShouldShowTS)
            case .review:
                return UserDefaults.standard.set(show, forKey: Constants.kReviewPopShouldShowTS)
            default: return
        }
    }
}

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
                UIImage.downloadImage(url: currentUser.avatarImageUrl, callback: { image in
                    let u = SessionManager.currentUser! // need to create a copy to update values and the copy needs to be done inside the callback
                    u.savedImaged = image
                    SessionManager.set(user: u)
                })
            }
        }
        
        self.checkAppVersion()
    }
    
    func handleLegislationUpdate(serverDate: Date?, type: PopoverType) {
        if let last = type.lastTS {
            if last != serverDate?.timeIntervalSince1970 {
                self.performSegue(withIdentifier: "legislation_segue", sender: ["type": type, "date": serverDate!.timeIntervalSince1970])
            }
        } else {
            type.setLastDate(lastTS: serverDate!.timeIntervalSince1970)
        }
    }
    
    func checkAppVersion() {
        // if it's a new version then set the 'shouldShow' for the review popover to true
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let storedVersion = UserDefaults.standard.value(forKey: Constants.storedVersionKey) as? String
            {
                if storedVersion != currentVersion {
                    PopoverType.review.setShoudShow(show: true)
                    UserDefaults.standard.set(currentVersion, forKey: Constants.storedVersionKey)
                }
                
            } else {
                UserDefaults.standard.set(currentVersion, forKey: Constants.storedVersionKey)
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
    
    @objc func showMenu()
    {
        self.popToRootViewController(animated: true)
        performSegue(withIdentifier: "menu_segue", sender: nil)
    }
    
    func handleRandomPopoverShow(type: PopoverType)
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
        
        if let shouldShowPop = type.shouldShow
        {
            if shouldShowPop == false
            {
                return
            }
        }
    
        let currentTS = NSDate().timeIntervalSince1970
        if let lastDateTS = type.lastTS
        {
            if currentTS - lastDateTS >= type.minDifference
            {
                // show popover
                type.setLastDate(lastTS: currentTS)
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (t) in
                    DispatchQueue.main.async {
                        switch type {
                        case .lucky:
                            self.showLuckyPopover(automatic: true)
                        case .review:
                            self.showReviewPopover(automatic: true)
                        default:
                            return
                        }
                        
                    }
                })
            }
        } else
        {
            type.setLastDate(lastTS: currentTS)
        }
    }
    
    @objc func lifesPressed()
    {
        self.showLuckyPopover()
    }
    
    func showLuckyPopover(automatic: Bool = false)
    {
        self.automaticTriggerForLuckyPop = automatic
        self.goTo(LuckyModalViewController.self, identifier: "lucky_segue")
    }
    
    func showReviewPopover(automatic: Bool = false)
    {
        self.goTo(ReviewModalViewController.self, identifier: "review_segue")
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
        self.handleRandomPopoverShow(type: .lucky)
        self.handleRandomPopoverShow(type: .review)
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
            case "legislation_segue":
                if let data = sender as? Dictionary<String, Any>
                {
                    let type = data["type"] as? PopoverType
                    let date = data["date"] as? TimeInterval
                    let modal = (segue.destination as! InformativePopoverViewController)
                    modal.type = type!
                    modal.dismissCallback = { () -> Void in
                        type!.setLastDate(lastTS: date!)
                    }
                }
                break
            case "lucky_segue":
                if automaticTriggerForLuckyPop
                {
                    (segue.destination as! LuckyModalViewController).shouldShowDoNotShow = true
                }
                break
            case "review_segue":
                (segue.destination as! ReviewModalViewController).navController = self
                break
            case "menu_segue":
                let menuController = (segue.destination as! UISideMenuNavigationController).topViewController! as! MenuViewController
                menuController.actionCallback = {(action) in
                    switch action {
                    case MenuViewController.kMenuActionContact:
                        self.goTo(ContactUsViewController.self, identifier: "contact_segue")
                        break
                    case MenuViewController.kMenuActionProfile:
                        self.goTo(AccountViewController.self, identifier: "account_segue")
                        break
                    case MenuViewController.kMenuActionLogout:
                        self.performSegue(withIdentifier: "logout_segue", sender: nil)
//                        self.goTo(LogoutViewController.self, identifier: "logout_segue")
                        break
                    case MenuViewController.kMenuQuickGame:
                        let controller = UIStoryboard(name: "Game", bundle: nil).instantiateViewController(withIdentifier: "WaitOpponent") as! WaitOpponentViewController
                        controller.fromInvite = true
                        self.pushViewController(controller, animated: true)
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
    
    /*
     if let identifier = segue.identifier {
     if identifier == "wait_opponent_segue" {
     let waitController = segue.destination as! WaitOpponentViewController
     waitController.fromInvite = true
     }
     }
     
     */

}
