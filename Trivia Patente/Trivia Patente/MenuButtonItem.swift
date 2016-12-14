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
    
    var controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TPMenuViewController") as! TPMenuViewController
    
    lazy var tapRecognizer : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(imagePressed))
    }()
    var navController : TPNavigationController!
    init(callback : @escaping (MenuAction) -> (), sender : TPNavigationController) {
        super.init()
        imageView.addGestureRecognizer(tapRecognizer)
        self.customView = imageView
        self.navController = sender

        toggleMenuState(visible: false)
        controller.navController = self.navController
        controller.callback = { action in
            callback(action)
            self.toggleMenuState(visible: false)
        }

    }
    func toggleMenuState(visible : Bool) {
        if visible {
            self.navController.modalPresentationStyle = .overFullScreen
            self.navController.present(controller, animated: true, completion: nil)
        } else {
            controller.dismiss(animated: false, completion: nil)
        }
    }
    func isVisible() -> Bool {
        return controller.isBeingPresented
    }
    func imagePressed() {
        toggleMenuState(visible: !isVisible())
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
