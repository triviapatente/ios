//
//  TPGameViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 16/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

protocol GameControllerRequired {
    func join_room()
}

class TPGameViewController: BaseViewController {
    //defaults to true (on dismiss, it goes to mainviewcontroller)
    var socketHandler = SocketGame()
    
    var mainOnDismiss : Bool {
        return true
    }
    override func needsMenu() -> Bool {
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParentViewController {
            socketHandler.unlistenAllEvents()
        }
        super.viewWillDisappear(animated)
    }
}
