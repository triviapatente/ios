//
//  LuckyModalViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 30/10/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class LuckyModalViewController: UIViewController {
    
    @IBOutlet var mainContainer : UIView!
    @IBOutlet var doNotShowCheckbox : UIView!
    
    var dnsaController : DNSAViewController!
    
    var shouldShowDoNotShow : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mainContainer.mediumRounded()
        if self.shouldShowDoNotShow
        {
            self.showDoNotShowCheckbox()
        }
        
        self.setShouldShowLuckyPop(show: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissModal()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setShouldShowLuckyPop(show : Bool)
    {
        UserDefaults.standard.set(show, forKey: Constants.kLuckyPopShouldShowTS)
    }
    
    @IBAction func stopPropagation() // prevent a tap on the modal itself to dismiss it
    {}
    
    func showDoNotShowCheckbox()
    {
        self.doNotShowCheckbox.isHidden = false
    }
    
    @IBAction func shareButtonClicked(sender: UIButton) {
        let textToShare = "Hey! Scarica anche tu l'applicazione Trivia Patente cos' ci possiamo sfidare!"
        
        if let myWebsite = NSURL(string: "http://www.apple.com/") {
            let objectsToShare = [textToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
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
                self.dnsaController.toggleCallback = { (checked) -> Void in
                    self.setShouldShowLuckyPop(show: !self.dnsaController.DNSAChecked)
                }
                break
            default:
                break
            }
        }
    }
    

}