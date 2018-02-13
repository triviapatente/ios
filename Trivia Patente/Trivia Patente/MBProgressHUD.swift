//
//  MBProgressHUD.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 23/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    class func getBottomAnchorPoint(view : UIView) -> CGPoint {
        return CGPoint(x: view.bounds.size.width / 2, y: view.bounds.size.height - 40)
    }
    class func error(_ message : String, view : UIView) {
        let errorView = MBProgressHUD.clearAndShow(to: view, animated: true)
        errorView.mode = .text
        errorView.center = self.getBottomAnchorPoint(view: view)
        errorView.detailsLabel.text = message
        errorView.hide(animated: true, afterDelay: 6)
    }
    class func clearAndShow(to: UIView, animated: Bool) -> MBProgressHUD {
        MBProgressHUD.hide(for: to, animated: false)
        return MBProgressHUD.showAdded(to: to, animated: animated)
    }
}
