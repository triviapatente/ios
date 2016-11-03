//
//  UIMenuViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 03/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class UIMenuViewController: UITableViewController {

    let options = [MenuAction.profile, MenuAction.settings, MenuAction.credits, MenuAction.logout]
    var callback : ((MenuAction) -> Void)!
    let CELL_HEIGHT : CGFloat = 50
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //size in popover
        let dimension = CELL_HEIGHT * CGFloat(options.count)
        self.preferredContentSize = CGSize(width: dimension, height: dimension)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.superview?.layer.cornerRadius = 0;

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "options_cell")!
        cell.textLabel?.text = options[indexPath.row].rawValue
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)

        let action = options[indexPath.row]
        callback(action)
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
