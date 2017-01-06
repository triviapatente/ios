//
//  sdf.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 30/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

let DARK_OFFSET = CGFloat(0.05)

extension UIButton {

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let color = self.backgroundColor {
            if color != .clear {
                self.backgroundColor = color.darker(offset: DARK_OFFSET)
            }
        }
        super.touchesBegan(touches, with: event)
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let color = self.backgroundColor {
            if color != .clear {
                self.backgroundColor = color.darker(offset: -DARK_OFFSET)
            }
        }
        super.touchesEnded(touches, with: event)
    }

}
