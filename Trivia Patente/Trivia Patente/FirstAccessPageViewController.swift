//
//  FirstAccessPageViewController.swift
//  Trivia Patente
//
//  Created by Antonio Terpin on 05/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class FirstAccessPageViewController: UIPageViewController {

    lazy var controllers: [UIViewController] = {
        return [self.instantiateController("RegistrationViewController"),
                self.instantiateController("WelcomeViewController"),
                self.instantiateController("LoginViewController")]
    }()
    var mainController : UIViewController {
        let mid = controllers.count / 2
        return controllers[mid]
    }
    var loginController : UIViewController {
        return controllers[2]
    }
    var registrationController : UIViewController {
        return controllers[0]
    }
    
    private func instantiateController(_ name: String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: name)
    }
    func gotoLogin() {
        setViewControllers([loginController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    func gotoMain() {
        setViewControllers([mainController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    func gotoRegister() {
        setViewControllers([registrationController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = mainController.view.backgroundColor
        gotoMain()
    }

    

}


