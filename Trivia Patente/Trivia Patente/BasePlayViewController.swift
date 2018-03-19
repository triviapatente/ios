//
//  BasePlayViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 17/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CollieGallery

class BasePlayViewController: TPGameViewController {
    
    static let SWIPE_DRAG_PERCENTAGE = CGFloat(0.3)
    static let SWIPE_DRAG_ANIMATION_DURATION : TimeInterval = 0.2
    
    @IBOutlet weak var bannerView : GADBannerView!
    var stackViewController : GCStackViewController!
    var pageControl : GCPageControlView!
    
    var imageAnimationStartView : UIView?
    
    var gameActions : TPGameActions! {
        didSet {
            
        }
    }
    
    var questions : [Quiz] = [] {
        didSet {
            guard !questions.isEmpty else {
                return
            }
            self.stackViewController.reloadData()
            var unansweredIndex : Int? = nil
            for i in 0..<questions.count {
                let question = questions[i]
                if let _ = question.my_answer {
                } else if unansweredIndex == nil {
                    unansweredIndex = i
                }
            }
            DispatchQueue.main.async {
                self.pageControl.reloadData()
                self.pageControl.view.isHidden = false
                self.gotoQuiz(i: unansweredIndex != nil ? unansweredIndex! : 0)
            }
        }
    }
    
    let BORDER_LENGTH = CGFloat(10)
    var currentPage : Int {
        return self.stackViewController.currentIndex
    }

    func gotoQuiz(i : Int) {
        DispatchQueue.main.async {
            self.stackViewController.scrollTo(index : i, animated: true, fastAnimation: false);
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func exitPlaying() {
        self.navigationController!.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageControl.view.clipsToBounds = true
        self.stackViewController.contentInset = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        self.pageControl.view.isHidden = true
        
        // AD banner load
        self.bannerView.adUnitID = Constants.BannerUnitID
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
        self.setDefaultBackgroundGradient()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let identifier = segue.identifier
        if identifier == "game_actions" {
            self.gameActions = segue.destination as! TPGameActions
        } else if identifier == "page_control" {
            self.pageControl = segue.destination as! GCPageControlView
            self.pageControl.delegate = self
        } else if identifier == "stack_view" {
            self.stackViewController = segue.destination as! GCStackViewController
            self.stackViewController.delegate = self
            self.stackViewController.dataSource = self
            self.stackViewController.itemViewNibName = "ShowQuizStackItemView"
        }
    }
    
    func allAnswered() -> Bool {
        for question in questions {
            if question.my_answer == nil {
                return false
            }
        }
        return true
    }
    
    func nextQuiz() -> Int? {
        for i in 1...self.questions.count {
            let candidate = (self.stackViewController.currentIndex + i) % questions.count
            if self.questions[candidate].my_answer == nil {
                return candidate
            }
        }
        return nil
    }

}

extension BasePlayViewController : GCStackViewDataSource, GCStackViewDelegate {
    func numberOfItems() -> Int {
        return self.questions.count
    }
    func configureViewForItem(itemView: UIView, index: Int) {
        if let card = itemView as? ShowQuizStackItemView {
            card.quiz = self.questions[index]
            card.delegate = self
        }
    }
    func stackView(stackViewController: GCStackViewController, didDisplayItemAt index: Int) {
        //        self.pageControl.setIndex(to: index, propagate: false)
        self.pageControl.view.isUserInteractionEnabled = true
    }
    func stackView(stackViewController: GCStackViewController, willDisplayItemAt index: Int) {
        self.pageControl.setIndex(to: index, propagate: false)
        self.pageControl.view.isUserInteractionEnabled = false
    }
}

extension BasePlayViewController : ShowQuizCellDelegate {
    func user_answered(answer: Bool, correct: Bool, quiz: Quiz) {
        
    }
    
    func trainMode() -> Bool {
        return false
    }
    
    func textForMainLabel() -> String {
        return "Questionario"
    }
    
    func opponentUser() -> User? {
        return nil
    }
    
    func headerRightSideData() -> Category? {
        return nil
    }
    
    func scroll_to_next() -> Bool {
        return self.stackViewController.scrollToNext()
    }
    
    
    func presentImage(image: UIImage?, target: UIView) {
        if let i = image {
            self.imageAnimationStartView = target
            let picture = CollieGalleryPicture(image: i)
            let gallery = CollieGallery(pictures: [picture])
            let zoomTransition = CollieGalleryTransitionType.zoom(fromView: target, zoomTransitionDelegate: self)
            gallery.presentInViewController(self, transitionType: zoomTransition)
        }
    }
}

extension BasePlayViewController : CollieGalleryZoomTransitionDelegate {
    
    func zoomTransitionContainerBounds() -> CGRect {
        return self.view.frame
    }
    func zoomTransitionViewToDismissForIndex(_ index: Int) -> UIView? {
        return self.imageAnimationStartView
    }
}

extension BasePlayViewController : CGPageControlDelegate {
    func customizeCellAt(index: Int, cell: PageControlCollectionViewCell) {
        cell.mainLabel.layer.borderColor = Colors.light_gray.cgColor
        if index < questions.count, let _ = self.questions[index].my_answer {
            cell.mainLabel.layer.borderColor = self.questions[index].answeredCorrectly! ? Colors.green_default.cgColor : Colors.red_default.cgColor
        }
    }
    func indexSelected(index: Int) {
        self.stackViewController.scrollTo(index: index, animated: true, propagate: false)
    }
    func numberOfPages() -> Int {
        return self.questions.count
    }
}

extension BasePlayViewController : GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
