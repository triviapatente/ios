//
//  InstagramFeedViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 02/05/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class InstagramFeedViewController: UIViewController {
    
    @IBOutlet var mainImageView : UIImageView!
    @IBOutlet var leftButton : UIButton!
    @IBOutlet var rightButton : UIButton!
    
    var pictures : [String]? = ["https://scontent.cdninstagram.com/vp/864f3bfec281359689f7643c0979ad73/5B8FF7DA/t51.2885-15/s320x320/e35/30841590_1667429793336347_5224128018166841344_n.jpg", "https://scontent.cdninstagram.com/vp/da98f19b2bb9a6c53b3acada45e618f1/5AEB7467/t51.2885-15/e15/p320x320/30917971_1233163293486315_5083115643314634752_n.jpg"] // nil = not loaded
    
    var timer : Timer? = nil
    var currentIndex : Int = 0
    
    let httpManager = HTTPManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        // Do any additional setup after loading the view.
        self.leftButton.circleRounded()
        self.rightButton.circleRounded()
//        self.mainImageView.mediumRounded()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (t) in
            DispatchQueue.main.async {
                self.downloadContent()
            }
        }
    }
    
    func downloadContent() {
//        httpManager.request(url: "https://api.instagram.com/v1/users/self/media/recent/?access_token=7547904163.2fef49b.06b60bdfda3348f49ff13020d87c5d34", method: .post, params: [:], auth: false) {  (response: TPResponse) in
        
        // set pictures to retrieved values, then
        self.startShowingFeed()
//        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startShowingFeed() {
        // all images have been downloaded
        self.view.isHidden = false
        self.startTimer()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (t) in
            self.showPictureAtIndex(index: self.currentIndex + 1)
        })
    }
    
    func showPictureAtIndex(index : Int) {
        guard self.pictures != nil else { return }
        if let t = self.timer {
            t.invalidate()
        }
        currentIndex = index
        mainImageView.load(path: URL(string: self.pictures![abs(currentIndex%self.pictures!.count)])!, placeholder: "insta-post")
        self.startTimer()
    }
    
    @IBAction func nextPictureAction() {
        self.showPictureAtIndex(index: currentIndex + 1)
    }

    @IBAction func prevoiusPictureAction() {
        self.showPictureAtIndex(index: currentIndex - 1)
    }
    
    
    /* TIME TRACK */
//    let lastInstaFeedShowKey = "lastInstaFeedShow"
//    let timeBetweenSessions : TimeInterval = 0*60*60*24 // 1 day
//    func sessionStarted() {
//        let now = Date().timeIntervalSince1970
//        UserDefaults.standard.set(now, forKey: lastInstaFeedShowKey)
//    }
//
//    func shouldStartSession() -> Bool {
//        if UserDefaults.standard.value(forKey: lastInstaFeedShowKey) == nil { return true }
//        let lastTime = UserDefaults.standard.value(forKey: lastInstaFeedShowKey) as! TimeInterval
//        return (Date().timeIntervalSince1970 - lastTime) > timeBetweenSessions
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
