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
    @IBOutlet var closeButton : UIButton!
    
    var pictures : [InstaPost]? = nil// nil = not loaded
    
    var timer : Timer? = nil
    var currentIndex : Int = 0
    
    let httpManager = HTTPManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isHidden = true
        // Do any additional setup after loading the view.
        self.leftButton.circleRounded()
        self.rightButton.circleRounded()
        self.closeButton.circleRounded()
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
        httpManager.request(url: "/ws/instagram", method: .get, params: nil) { (response:TPInstaFeedResponse) in
            if response.success {
                if let images = response.posts {
                    self.pictures = images
                    self.startShowingFeed()
                }
            }
        }
        
//        }
        
        
    }
    
    @IBAction func openInstaPost() {
        // url for image at currentIndex
        let url = URL(string: getCurrentPost().postLink)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
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
        mainImageView.load(path: URL(string: getCurrentPost().url)!, placeholder: "insta-post")
        self.startTimer()
    }
    
    func getCurrentPost() -> InstaPost {
        return self.pictures![abs(currentIndex%self.pictures!.count)]
    }
    
    @IBAction func nextPictureAction() {
        self.showPictureAtIndex(index: currentIndex + 1)
    }

    @IBAction func prevoiusPictureAction() {
        self.showPictureAtIndex(index: currentIndex - 1)
    }
    
    @IBAction func closeInstaFeed() {
        if let t = timer {
            t.invalidate()
        }
        self.view.isHidden = true
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
