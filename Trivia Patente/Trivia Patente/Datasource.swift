//
//  Datasource.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension FirstAccessPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //guard non fa altro che controllare se la condizione è verificata, se non lo è returna nil
        guard let index = controllers.index(of: viewController) else {
            return nil
        }
        if index == 0 {
            return nil
        }
        return self.controllers[index - 1]
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count
    }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return self.controllers.count / 2
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
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
