//
//  RightMessageTableViewCell.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 10/12/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    @IBOutlet var dateLabel : UILabel!
    @IBOutlet var messageView : UITextView!
    
    var message : Message! {
        didSet {
            self.messageView.text = message.content
            self.dateLabel.text = message.createdAt?.pretty
        }
    }
    var textViewInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    func height(for text : String) -> CGFloat {
        self.messageView.text = text
        return self.messageView.requiredHeight + textViewInset.top + textViewInset.bottom
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageView.mediumRounded()
        self.messageView.contentInset = textViewInset
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
