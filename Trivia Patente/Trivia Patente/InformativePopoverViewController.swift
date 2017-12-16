//
//  InformativePopoverViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 13/12/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class InformativePopoverViewController: BaseViewController {
    
    @IBOutlet weak var mainContainer : UIView!
    @IBOutlet weak var mainText : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainContainer.mediumRounded()
        self.updatePopoverMessage()
    }
    
    var type : PopoverType = .privacyUpdate
    var dismissCallback : (() -> Void)?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPropagation() // prevent a tap on the modal itself to dismiss it
    {}
    
    @IBAction func dismissModal()
    {
        // save last date
        if let cb = self.dismissCallback {
            cb()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatePopoverMessage() {
        var message : NSMutableAttributedString
        switch type {
        case .privacyUpdate:
            message = NSMutableAttributedString(string: Strings.legislation_pop_privacy_update_1)
            if #available(iOS 11.0, *) {
                message.append(NSAttributedString(string: Strings.legislation_pop_privacy_update_2, attributes: [NSForegroundColorAttributeName: UIColor(named: "text-highlight") ?? Colors.text_highlight]))
            } else {
                // Fallback on earlier versions
                message.append(NSAttributedString(string: Strings.legislation_pop_privacy_update_2, attributes: [NSForegroundColorAttributeName: Colors.text_highlight]))
            }
        case .termsUpdate:
            message = NSMutableAttributedString(string: Strings.legislation_pop_terms_update_1)
            if #available(iOS 11.0, *) {
                message.append(NSAttributedString(string: Strings.legislation_pop_terms_update_2, attributes: [NSForegroundColorAttributeName: UIColor(named: "text-highlight") ?? Colors.text_highlight]))
            } else {
                // Fallback on earlier versions
                message.append(NSAttributedString(string: Strings.legislation_pop_terms_update_2, attributes: [NSForegroundColorAttributeName: Colors.text_highlight]))
            }
        default:
            message = NSMutableAttributedString(string: "") // never happens
            break
        }
        self.mainText.attributedText = message
    }
    
    @IBAction func mainTextClicked() {
        switch type {
        case .privacyUpdate:
            self.openURL(url: URL(string: HTTPManager.getBaseURL() + "/ws/privacyPolicy")!)
            break
        case .termsUpdate:
            self.openURL(url: URL(string: HTTPManager.getBaseURL() + "/ws/terms")!)
            break
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
