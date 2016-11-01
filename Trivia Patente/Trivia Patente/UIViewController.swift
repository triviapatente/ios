//
//  UIViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UIViewController {
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
    
    class func goToFirstAccess(from : UIViewController? = nil) {
        var sender = from
        if sender == nil {
            sender = self.getVisible()
        }
        if let visibleViewController = sender {
            let destination = self.firstAccessController()
            
            let controller = UIAlertController(title: "Sessione scaduta", message: "Riaccedi per continuare", preferredStyle: .alert)
            let action = UIAlertAction(title: "Continua", style: .default, handler: { action in
                
                visibleViewController.present(destination, animated: true, completion: {
                    destination.gotoLogin()
                })
            })
            controller.addAction(action)
            visibleViewController.present(controller, animated: true, completion: nil)

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
                print(navigationController.viewControllers)
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
}
