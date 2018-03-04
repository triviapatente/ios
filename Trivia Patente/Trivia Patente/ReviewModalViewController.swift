//
//  ReviewModalViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 12/12/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class ReviewModalViewController: BaseViewController {
    
    @IBOutlet var mainContainer : UIView!
    @IBOutlet var doNotShowCheckbox : UIView!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var mainText : UILabel!
    @IBOutlet weak var initialButtonsContainer: UIStackView!
    
    var dnsaController : DNSAViewController!
    
    var navController : TPNavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mainContainer.mediumRounded()
        self.showDoNotShowCheckbox()
    }
    
    @IBAction func dismissModal()
    {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func initialFeedback(sender: UIButton) {
        self.initialButtonsContainer.isHidden = true
        self.singleButton.isHidden = false
        
        PopoverType.review.setShoudShow(show: false)
        
        if sender == self.leftButton { // negative
            self.singleButton.setTitle(Strings.review_pop_negative_btn, for: .normal)
            self.mainText.text = Strings.review_pop_negative_msg
            self.singleButton.addTarget(self, action: #selector(goToContactUs), for: .touchUpInside)
        } else { // positive
            self.singleButton.setTitle(Strings.review_pop_positive_btn, for: .normal)
            self.mainText.text = Strings.review_pop_positive_msg
            self.singleButton.addTarget(self, action: #selector(externalReview), for: .touchUpInside)
        }
    }
    
    @objc func goToContactUs() {
        self.dismissModal()
        if let nav = self.navController {
            nav.goTo(ContactUsViewController.self, identifier: "contact_segue")
        }
    }
    
    @objc func externalReview() {
        self.dismissModal()
        self.openURL(url: URL(string: HTTPManager.getBaseURL() + "/ws/store_page/ios")!)
    }
    
    @IBAction func stopPropagation() // prevent a tap on the modal itself to dismiss it
    {}
    
    func showDoNotShowCheckbox()
    {
        self.doNotShowCheckbox.isHidden = false
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destination
        if let identifier = segue.identifier {
            switch identifier {
            case "dnsa":
                self.dnsaController = destination as! DNSAViewController
                self.dnsaController.toggleCallback = {   (checked) -> Void in
                    guard self != nil else { return }
                    PopoverType.review.setShoudShow(show: !self.dnsaController.DNSAChecked)
                }
                break
            default:
                break
            }
        }
    }
    

}
