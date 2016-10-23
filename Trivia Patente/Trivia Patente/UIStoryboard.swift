//
//  UIStoryboard.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func getController<T: UIViewController>(storyboard : String, controller : T.Type) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let identifier = String(describing: controller)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    class func getFirstController(storyboard : String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        return storyboard.instantiateInitialViewController()!
    }
    
}
