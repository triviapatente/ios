//
//  UIViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD


protocol TPViewController {
    func needsMenu() -> Bool
}

extension UIViewController : TPViewController {
    internal func needsMenu() -> Bool {
        return true
    }
    
    class func root() -> UIViewController {
        if SessionManager.isLogged() {
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
    
    func handleGenericError(message: String, dismiss: Bool = false) {
        self.showToast(text: message)
        if dismiss {
            Timer.scheduledTimer(withTimeInterval: Constants.toastDuration, repeats: false, block: { t in
                DispatchQueue.main.async {
                    if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    func genericConnectionError(dismiss: Bool = false) {
        self.handleGenericError(message: Strings.no_connection_toast)
    }
    
    func showGenericError() {
        self.showToast(text: Strings.generic_error)
    }
    
    func openURL(url: URL)
    {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func showToast(text: String)
    {
        UIViewController.showToast(text: text, view: self.view)
    }
    
    class func showToast(text: String, view: UIView)
    {
        view.endEditing(true)
        let toast = MBProgressHUD.clearAndShow(to: view, animated: true)
        toast.mode = .text
        toast.label.text = text
        toast.label.numberOfLines = 0
        toast.removeFromSuperViewOnHide = true
        
        toast.hide(animated: true, afterDelay: Constants.toastDuration)
    }
}
