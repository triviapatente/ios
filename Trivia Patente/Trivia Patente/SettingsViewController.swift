//
//  SettingsViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 13/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var profileItems =      [PreferenceItem(type: .profile, segue: "account_segue", height: 100)]
    var privacyItems =      [PreferenceItem(title: "Condividi le mie statistiche", image: "preference_stats", type: .dropdown),
                             PreferenceItem(title: "Cambia password", image: "preference_password", type: .normal, segue: "change_password_segue")]
    var chatItems =         [PreferenceItem(title: "Chi mi può contattare:", image: "preference_chat", type: .dropdown)]
    var notificationItems = [PreferenceItem(title: "Inviti alle partite", image: "preference_new_invite", type: .switchable),
                             PreferenceItem(title: "E' il mio turno", image: "preference_my_turn", type: .switchable),
                             PreferenceItem(title: "Ho un nuovo messaggio", image: "preference_new_message", type: .switchable),
                             PreferenceItem(title: "Ho tutte le vite disponibili", image: "preference_full_hearts", type: .switchable)]
    var inviteItems =       [PreferenceItem(title: "Dillo a un amico!", image: "preference_tell_a_friend", type: .normal, segue: "tell_a_friend_segue")]
    
    var items : [[PreferenceItem]] {
        get {
            return [profileItems, privacyItems, chatItems, notificationItems, inviteItems]
        }
    }
    var titles = ["", "Sicurezza e privacy", "Chat", "Notifiche", ""]
    
    func itemFor(indexPath : IndexPath) -> PreferenceItem {
        return items[indexPath.section][indexPath.row]
    }
    
    func registerCells() {
        self.tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: PreferenceType.normal.rawValue)
        self.tableView.register(DropdownSettingsTableViewCell.self, forCellReuseIdentifier: PreferenceType.dropdown.rawValue)
        self.tableView.register(SwitchableSettingsTableViewCell.self, forCellReuseIdentifier: PreferenceType.switchable.rawValue)
        
        let nib = UINib(nibName: "ProfileSettingsTableViewCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: PreferenceType.profile.rawValue)
        
        let headerNib = UINib(nibName: "SettingsHeaderView", bundle: Bundle.main)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemFor(indexPath: indexPath).height
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section != 0 else {
            return 0
        }
        return 40
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section != 0 else {
            return nil
        }
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SettingsHeaderView
        view.titleView.text = titles[section]
        return view
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.itemFor(indexPath: indexPath)
        let identifier = item.type.rawValue
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! SettingsTableViewCell
        cell.item = item
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.itemFor(indexPath: indexPath)
        if let segue = item.segue {
            self.performSegue(withIdentifier: segue, sender: self)
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
