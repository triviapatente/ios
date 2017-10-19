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
                self.instantiateController("LoginViewController")]
    }()
    
    let firstControllerIndex = 0 // corresponds to RegistrationViewController in self.controllers
    
    var mainController : UIViewController {
        return controllers[firstControllerIndex]
    }
    var loginController : UIViewController {
        return controllers[1] // corresponds to LoginViewController in self.controllers
    }
    var registrationController : UIViewController {
        return controllers[0] // corresponds to RegistrationViewController in self.controllers
    }
    var viewControllerToPresent : UIViewController!
    
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
    func present() {
        if viewControllerToPresent == nil {
            viewControllerToPresent = mainController
        }
        setViewControllers([viewControllerToPresent], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = mainController.view.backgroundColor
        present()
    }

    

}


