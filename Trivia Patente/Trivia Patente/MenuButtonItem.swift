//
//  MenuButtonItem.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class MenuButtonItem: UIBarButtonItem, UIPopoverPresentationControllerDelegate {
    
    lazy var imageView : UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let view = UIImageView(frame: rect)
        view.image = UIImage(named: "menu_dots")
        return view
    }()
    
    var optionsOrigin : CGPoint! {
        didSet {
            controller.view.frame.origin = optionsOrigin
        }
    }
    var optionsFrame : CGSize! {
        get {
            return controller.view.frame.size
        }
    }
    var controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UIMenuViewController") as! UIMenuViewController
    
    lazy var tapRecognizer : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(imagePressed))
    }()
    
    init(callback : @escaping (MenuAction) -> (), sender : TPNavigationController) {
        super.init()
        imageView.addGestureRecognizer(tapRecognizer)
        self.customView = imageView

        toggleMenuState(visible: false, animate: false)
        controller.callback = { action in
            self.toggleMenuState(visible: false)
            callback(action)
        }
        
        sender.view.addSubview(controller.view)

    }
    func toggleMenuState(visible : Bool, animate : Bool = true) {
        let endAlpha = CGFloat(visible ? 1 : 0)
        guard endAlpha != controller.view.alpha else {
            return
        }
        if animate == true {
            UIView.animate(withDuration: 0.2) {
                self.controller.view.alpha = endAlpha
            }
        } else {
            self.controller.view.alpha = endAlpha
        }
    }
    func isVisible() -> Bool {
        return controller.view.alpha > 0
    }
    func imagePressed() {
        toggleMenuState(visible: !isVisible())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
