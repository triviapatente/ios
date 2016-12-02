//
//  UINavigationController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UINavigationController {
    func removeViewController(at index : Int) {
        self.viewControllers.remove(at: index)
    }
    func removeLastViewController() {
        let index = self.viewControllers.count - 1
        self.removeViewController(at: index)
    }
    func removeViewController(for type: UIViewController.Type) {
        if let index = self.index(for : type) {
            self.removeViewController(at: index)
        }
    }
    func index(for type: UIViewController.Type) -> Int? {
        for i in 0..<self.viewControllers.count {
            let item = self.viewControllers[i]
            if item.isKind(of: type) {
                return i
            }
        }
        return nil
    }
}
