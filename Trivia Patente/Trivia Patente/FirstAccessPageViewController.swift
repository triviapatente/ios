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
        return [self.instantiateController(name: "MainViewController"),
                self.instantiateController(name: "LoginViewController"),
                self.instantiateController(name: "RegistrationViewController")]
    }()
    
    private func instantiateController(name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        let first = controllers.first!
        setViewControllers([first], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
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

extension FirstAccessPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        //guard non fa altro che controllare se la condizione è verificata, se non lo è returna nil
        guard let index = controllers.index(of: viewController) else {
            return nil
        }
        if index == 0 {
            return nil
        }
        return self.controllers[index - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // TODO
        //guard non fa altro che controllare se la condizione è verificata, se non lo è returna nil
        guard let index = controllers.index(of: viewController) else {
            return nil
        }
        if index >= (controllers.count - 1) {
            return nil
        }
        return self.controllers[index + 1]
    }
}
