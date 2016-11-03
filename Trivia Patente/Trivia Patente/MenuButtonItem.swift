//
//  MenuButtonItem.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class MenuButtonItem: UIBarButtonItem {
    
    lazy var imageView : UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let view = UIImageView(frame: rect)
        view.image = UIImage(named: "menu_dots")
        return view
    }()
    
    var controller : UIMenuViewController!
    var sender : TPNavigationController!
    
    lazy var tapRecognizer : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(imagePressed))
    }()
    
    init(callback : @escaping (MenuAction) -> (), sender : TPNavigationController) {
        super.init()
        imageView.addGestureRecognizer(tapRecognizer)
        self.customView = imageView

        self.sender = sender
        controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "UIMenuViewController") as! UIMenuViewController
        controller.callback = callback

    }
    func imagePressed() {
        if controller.isBeingPresented {
            controller.dismiss(animated: true, completion: nil)
        } else {
            presentController(sender: self.sender)
        }
    }
    func presentController(sender : TPNavigationController) {
        controller.modalPresentationStyle = .popover
        controller.modalTransitionStyle = .crossDissolve
        sender.present(controller, animated: true, completion: nil)
        
        if let presentationController = controller.popoverPresentationController {
            presentationController.sourceView = self.imageView
            presentationController.sourceRect = CGRect(x: 0, y: 0, width: self.imageView.bounds.size.width, height: self.imageView.bounds.size.width)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
