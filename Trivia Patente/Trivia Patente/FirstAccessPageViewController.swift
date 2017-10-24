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
    
    let firstControllerIndex = 0 //  RegistrationViewController in self.controllers
    
    var mainController : UIViewController {
        return controllers[firstControllerIndex]
    }
    var loginController : UIViewController {
        return controllers[1] //  LoginViewController in self.controllers
    }
    var registrationController : UIViewController {
        return controllers[0] //  RegistrationViewController in self.controllers
    }
    var viewControllerToPresent : UIViewController!
    
    private func instantiateController(_ name: String) -> UIViewController {
        return self.storyboard!.instantiateViewController(withIdentifier: name)
    }
    func gotoLogin() {
        self.viewControllerToPresent = loginController
        setViewControllers([loginController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    func gotoMain() {
        setViewControllers([mainController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    func gotoRegister() {
        self.viewControllerToPresent = registrationController
        setViewControllers([registrationController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    func present() {
        if viewControllerToPresent == nil {
            viewControllerToPresent = mainController
        }
        setViewControllers([viewControllerToPresent], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set gardient background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [Colors.access_top_color.cgColor, Colors.access_bottom_color.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        self.view.backgroundColor = Colors.access_bottom_color // set base color
        
        NotificationCenter.default.addObserver(self, selector: #selector(gotoLogin), name: Notification.Name("slideToLogin"), object: nil)
        
        present()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}


