//
//  DNSAViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 31/10/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class DNSAViewController: UIViewController {

    @IBOutlet var checkbox : UIImageView!
    var DNSAChecked : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var toggleCallback : ((Bool) -> Void)?

    func updateCheckboxImage()
    {
        if self.DNSAChecked
        {
            self.checkbox.image = UIImage(named: "ticked")
        } else {
            self.checkbox.image = UIImage(named: "check-empty")
        }
    }
    
    @IBAction func toggleDNSA()
    {
        self.DNSAChecked = !self.DNSAChecked
        if let tg = self.toggleCallback
        {
            tg(self.DNSAChecked)
        }
        self.updateCheckboxImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
