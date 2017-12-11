//
//  UiButton.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
let LOADING_VIEW_TAG = 233
class TPButton : UIButton {
    var prevTitle : String!
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.setBackgroundColor(color: Colors.button_highlighted_color, forState: UIControlState.highlighted)
    }
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    func load() {
        self.isEnabled = false
        prevTitle = self.title(for: .normal)
        self.setTitle("", for: .normal)
        let view = UIActivityIndicatorView(activityIndicatorStyle: .white)
        view.startAnimating()
        view.tag = LOADING_VIEW_TAG
        let dim = self.bounds.size.height - 10
        view.frame = CGRect(x: self.bounds.size.width / 2 - dim / 2, y: self.bounds.size.height / 2 - dim / 2, width: dim, height: dim)
        self.addSubview(view)
        self.bringSubview(toFront: view)
    }
    func stopLoading() {
        self.isEnabled = true
        self.setTitle(prevTitle, for: .normal)
        if let loadingView = self.viewWithTag(LOADING_VIEW_TAG) {
            loadingView.removeFromSuperview()
        }
    }

}
