//
//  TPView.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 22/10/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class TPView: UIView {
    @IBOutlet private var contentView : UIView?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromNib()
    }
    func initFromNib() {
        let nib = String(describing: type(of: self))
        Bundle.main.loadNibNamed(nib, owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }

}
