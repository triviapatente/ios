//
//  UIViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit


protocol TPViewController {
    func needsMenu() -> Bool
}

extension UIViewController : TPViewController {
    internal func needsMenu() -> Bool {
        return true
    }

    class func root() -> UIViewController {
        if let _ = SessionManager.getToken() {
            return mainController()
        } else {
            return firstAccessController()
        }
    }
    class func firstAccessController() -> FirstAccessPageViewController {
        return UIStoryboard.getFirstController(storyboard: "FirstAccess") as! FirstAccessPageViewController
    }
    
    class func mainController() -> UINavigationController {
        return UIStoryboard.getFirstController(storyboard: "Main") as! UINavigationController
    }
    func fade(duration durationValue: Double? = nil) {
        if let duration = durationValue {
            self.view.fade(duration: duration)
        } else {
            self.view.fade()
        }
        self.dismiss(animated: false, completion: nil)
        
    }
    class func goToFirstAccess(from : UIViewController? = nil, expired_session : Bool = true) {
        var sender = from
        if sender == nil {
            sender = self.getVisible()
        }
        if let visibleViewController = sender {
            let destination = self.firstAccessController()
            if expired_session == true {
                let controller = UIAlertController(title: "Sessione scaduta", message: "Riaccedi per continuare", preferredStyle: .alert)
                let action = UIAlertAction(title: "Continua", style: .default, handler: { action in
                    destination.viewControllerToPresent = destination.loginController
                    visibleViewController.present(destination, animated: true)
                })
                controller.addAction(action)
                visibleViewController.present(controller, animated: true, completion: nil)
            } else {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.changeRootViewController(with: destination)
//                visibleViewController.present(destination, animated: true, completion: nil)
                
            }

        }
    }
    class func getVisible(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        var root = rootViewController
        if rootViewController == nil {
            root = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if let presented = root?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisible(presented)
        } else {
            return root
        }
    }
    func set(backgroundGradientColors colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.frame = self.view.bounds
        layer.colors = colors
        self.view.layer.insertSublayer(layer, at: 0)
    }
    func setDefaultBackgroundGradient() {
        self.set(backgroundGradientColors: [Colors.primary.cgColor, Colors.secondary.cgColor])
    }
    func setBackgroundGradientBounds(start: Float = 0, end: Float = 1) {
        let end = end > 0.2 ? end : 1 // temporary solution to a big issue
        if let sublayers = self.view.layer.sublayers {
            if let gradient = sublayers[0] as? CAGradientLayer {
                gradient.locations = [start as NSNumber, end as NSNumber]
            }
        }
    }
}
