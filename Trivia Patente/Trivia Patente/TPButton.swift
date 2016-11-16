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
    func load() {
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
        self.setTitle(prevTitle, for: .normal)
        if let loadingView = self.viewWithTag(LOADING_VIEW_TAG) {
            loadingView.removeFromSuperview()
        }
    }

}
