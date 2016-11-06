//
//  AvatarButtonItem.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 02/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class AvatarButtonItem: UIBarButtonItem {
    var user : User? {
        didSet {
            imageView.loadAvatar(candidate: user)
        }
    }
    var callback : (() -> ())!
    lazy var imageView : UIImageView = {
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let view = UIImageView(frame: rect)
        view.circleRounded()
        return view
    }()
    
    lazy var tapRecognizer : UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(pressAvatar))
    }()
    
    func pressAvatar() {
        self.callback()
    }
    init(user : User?, callback : @escaping () -> ()) {
        super.init()
        self.customView = imageView
        self.user = user
        self.callback = callback
        imageView.loadAvatar(candidate: user)
        imageView.addGestureRecognizer(tapRecognizer)

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}