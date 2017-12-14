//
//  NoConnectionViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 14/12/2017.
//  Copyright © 2017 Terpin e Donadel. All rights reserved.
//

import UIKit

class NoConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefaultBackgroundGradient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "error_view" {
                if let destination = segue.destination as? TPErrorView {
                    destination.set(error: "Spiacenti, impossibile connetersi al server 😔")
                }
            }
        }
    }
    

}
