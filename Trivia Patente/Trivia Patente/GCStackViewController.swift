//
//  GCStackViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 10/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class GCStackViewController: UIViewController {
    
    var delegate : GCStackViewDelegate?
    var dataSource : GCStackViewDataSource?
    var itemViewNibName : String?
    var contentInset : UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.reloadGraphics()
        }
    }
    var itemBackgroundColor : UIColor = Colors.light_blue {
        didSet {
            for v in self.itemViews {
                v.backgroundColor = itemBackgroundColor
            }
        }
    }
    var numberOfVisibleItems : Int = 4 {
        didSet {
            self.createVisibleViewContainers()
        }
    }
    
    var currentIndex : Int = 0 {
        didSet {
            orderChanged()
            loadContentForVisibleItems()
        }
    }
    
    var lastElementSelected : Bool {
        get {
            return currentIndex == dataSource!.numberOfItems() - 1 // TODO
        }
    }
    
    var fastAnimationDuration : TimeInterval = 0.2
    var slowAnimationDuration : TimeInterval = 0.5
    
    private var stackEffectDeepDegreeFixed = CGFloat(6)
    private var stackEffectSqueezeDegreeFixed = CGFloat(8)
    private var stackEffectOpacityStep = CGFloat(0.05)
    
    var itemViews : [GCStackItemContainerView] {
        get {
            return self.view.subviews as! [GCStackItemContainerView]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createVisibleViewContainers()
        self.reloadData()
    }
    
    private func reloadGraphics() {
        self.createVisibleViewContainers()
    }
    
    private func createVisibleViewContainers() {
        // Create the views
        self.view.removeAllSubviews()
        let animationFactor = CGFloat(1)
        for i in 0..<numberOfVisibleItems {
            let itemView = GCStackItemContainerView()
            
            self.view.addSubview(itemView)
            itemView.loadLayout(from: itemViewNibName!)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: contentInset.top*animationFactor))
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute:.bottom, multiplier: 1, constant: -contentInset.bottom*animationFactor))
            
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .leadingMargin, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1, constant: contentInset.left*animationFactor))
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .trailingMargin, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: -contentInset.right*animationFactor))
            self.customizeItemViewContainer(view: itemView)
        }
        self.orderChanged()
    }
    
    private func cardSize() -> CGSize {
        return CGSize(width: self.view.frame.width - contentInset.left - contentInset.right, height: self.view.frame.height - contentInset.top - contentInset.bottom)
    }
    
    private func orderChanged() {
        guard self.itemViews.count == numberOfVisibleItems else { return }
        self.originalLocation = CGPoint.zero
        for i in 0..<numberOfVisibleItems {
            let itemView = self.view.subviews[Int(i)]
//            itemView.transform = CGAffineTransform.identity
            itemView.gestureRecognizers!.first!.isEnabled = false
            if i == numberOfVisibleItems - 1 {
                itemView.gestureRecognizers!.first!.isEnabled = true
            }
        }
        checkRemaingItems()
        updateFrames(percentage: 0.0, includeTop: true, animated: false)
    }
    
    private func customizeItemViewContainer(view: GCStackItemContainerView) {
        view.mediumRounded()
        view.backgroundColor = itemBackgroundColor
        
        let itemPan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(gestureRecognizer:)))
        itemPan.cancelsTouchesInView = false
        view.addGestureRecognizer(itemPan)

        // shadow
        view.layer.shadowColor = Colors.dark_shadow.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4.0)
        view.layer.shadowRadius = 5.0
        view.layer.shadowOpacity = 1.0
        view.layer.masksToBounds = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        loadContentForVisibleItems()
        orderChanged()
//        self.updateFrames()
    }
    
    func scrollToNext(fastAnimation: Bool = true) -> Bool {
        if !lastElementSelected
        {
            animateAway(target: getTopItemView(), fastAnimation: fastAnimation) { (view) in
//                self.resetCard(target: view, animated: false)
                view.loaded = false
                self.currentIndex = self.currentIndex + 1
                
            }
            return true
        }
        return false
    }
    
    private func unloadAllItemViews() {
        for view in self.itemViews {
            view.loaded = false
        }
    }
    
    private func checkRemaingItems() {
        let totalItems = dataSource!.numberOfItems()
        let toDisplayNext = totalItems - currentIndex
        for i in 0..<itemViews.count {
            self.itemViews[i].isHidden = toDisplayNext < numberOfVisibleItems - i
        }
    }
    
    func scrollTo(index: Int, animated: Bool, fastAnimation: Bool = true) {
        scrollToNext(fastAnimation: fastAnimation)
    }
    
    private func loadContentForVisibleItems() {
        for i in (0..<itemViews.count).reversed() {
            let newIndex = currentIndex + (numberOfVisibleItems-1-i)
            if newIndex < dataSource!.numberOfItems() {
                let itemView = itemViews[i]
                if !itemView.loaded {
                    dataSource!.configureViewForItem(itemView: itemView.contentView!, index:newIndex)
                    itemView.loaded = true
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        updateFrames(percentage: lastPercentageUsed, includeTop: true, animated: false)
    }
    
    
    
    // CARD animations
    var originalLocation : CGPoint = CGPoint.zero
    var originalYScale = CGFloat(1.0)
    //conf
    var rotationMax = CGFloat(1.0)
    var defaultRotationAngle = CGFloat(1.0)
    var rotationStrength = CGFloat(1.0)
    var scaleMin = CGFloat(1.0)
    var animationDirection : CGFloat = 1.0
    var hasElementBehind = false
    @IBAction func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let target = gestureRecognizer.view! as! GCStackItemContainerView
        let xDistanceFromCenter = gestureRecognizer.translation(in: target).x
        let yDistanceFromCenter = gestureRecognizer.translation(in: target).y
        
        let touchLocation = gestureRecognizer.location(in: target)
        let yDiff = self.stackEffectDeepDegreeFixed*CGFloat(numberOfVisibleItems)
        switch gestureRecognizer.state {
        case .began:
            originalLocation = target.center
            originalYScale = 1//target.transform.d
            
            animationDirection = touchLocation.y >= target.frame.size.height / 2 ? -1.0 : 1.0
            target.layer.shouldRasterize = true
            break
            
        case .changed:
            
            let rotationStrength = min(xDistanceFromCenter / target.frame.size.width, rotationMax)
            let rotationAngle = animationDirection * defaultRotationAngle * rotationStrength
            let scaleStrength = 1 - ((1 - scaleMin) * fabs(rotationStrength))
            let scale = max(scaleStrength, scaleMin)
            
            target.layer.rasterizationScale = scale * UIScreen.main.scale
            
            let transform = CGAffineTransform(rotationAngle: rotationAngle)
            let scaleTransform = transform.scaledBy(x: scale, y: scale*self.originalYScale)
            
            target.transform = scaleTransform
            target.center = CGPoint(x: originalLocation.x + xDistanceFromCenter, y: originalLocation.y + yDistanceFromCenter + yDiff)
            
//            updateSecondaryAnimations(percentage: )
            updateFrames(percentage: xDistanceFromCenter / target.frame.size.width, includeTop: false)
            
            break
        case .ended:
            panEnded(percentage: xDistanceFromCenter / target.frame.size.width, target: target)
            target.layer.shouldRasterize = false
        default :
            break
        }
    }
    
//    private func updateSecondaryAnimations(percentage: CGFloat) {
//        let completionPercentage = min(abs(percentage) / PlayRoundViewController.SWIPE_DRAG_PERCENTAGE, 1)
//        for i in 0..<itemViews.count-1 {
//            let itemView = itemViews[i]
//            UIView.animate(withDuration: percentage == 0 ? PlayRoundViewController.SWIPE_DRAG_ANIMATION_DURATION : 0, animations: {
//                itemView.alpha = 1.0 - self.stackEffectOpacityStep*CGFloat(self.numberOfVisibleItems-1-i) + self.stackEffectOpacityStep*completionPercentage
//                //scale
//                let scaleX = (self.stackEffectSqueezeDegreeFixed * 2 / itemView.frame.width)*completionPercentage  + 1
//                let transormarion = CGAffineTransform(translationX: 0, y: self.stackEffectDeepDegreeFixed*completionPercentage)
//                itemView.transform = transormarion.scaledBy(x: scaleX, y: 1)
//            })
//
//        }
//    }
    private var lastPercentageUsed : CGFloat = 0.0
    private func updateFrames(percentage: CGFloat = 0.0, includeTop: Bool = true, animated: Bool = true) {
        lastPercentageUsed = percentage
        let size = cardSize()
        let completionPercentage = min(abs(percentage) / PlayRoundViewController.SWIPE_DRAG_PERCENTAGE, 1)
        for i in 0..<numberOfVisibleItems-(includeTop ? 0 : 1) {
            let itemView = self.view.subviews[Int(i)]
            let iCompl = CGFloat(numberOfVisibleItems-1-i)
//            itemView.transform = CGAffineTransform.identity
            UIView.animate(withDuration: animated ? PlayRoundViewController.SWIPE_DRAG_ANIMATION_DURATION : 0, animations: {
                print(itemView.alpha)
                itemView.alpha = itemView.alpha == 0.0 ? 0.0 : 1.0 - self.stackEffectOpacityStep*CGFloat(self.numberOfVisibleItems-1-i) + self.stackEffectOpacityStep*completionPercentage
                let scaleX = (size.width - (self.stackEffectSqueezeDegreeFixed*iCompl - self.stackEffectSqueezeDegreeFixed*completionPercentage)*CGFloat(2))/size.width
//                let scaleY = (size.height - (self.stackEffectDeepDegreeFixed*iCompl)*CGFloat(2))/size.height
                let scaleY = (size.height - (self.stackEffectDeepDegreeFixed*CGFloat((self.numberOfVisibleItems-1))))/size.height

                let transform = CGAffineTransform(translationX: 0, y:0)
                print(scaleY)
                print(size.height, scaleY*size.height, scaleY*size.height+(size.height*scaleY)/2+self.stackEffectDeepDegreeFixed*CGFloat(i)+self.stackEffectDeepDegreeFixed*completionPercentage)
                itemView.transform = transform.scaledBy(x: scaleX, y: scaleY)
                itemView.center = CGPoint(x: itemView.center.x, y: (size.height*scaleY)/2+self.stackEffectDeepDegreeFixed*CGFloat(i)+self.stackEffectDeepDegreeFixed*completionPercentage)
            })
            
        }
    }
    
    private func getTopItemView() -> GCStackItemContainerView {
        return self.view.subviews.last! as! GCStackItemContainerView
    }
    
    func panEnded(percentage: CGFloat, target: GCStackItemContainerView)
    {
        if abs(percentage) > PlayRoundViewController.SWIPE_DRAG_PERCENTAGE && !lastElementSelected {
            
            scrollToNext()
        } else {
            resetCard(target: target, animated: true)
            updateFrames(percentage: 0, includeTop: true)
        }
    }
    
    private func animateAway(target: GCStackItemContainerView, fastAnimation: Bool = true, completedCB: ((GCStackItemContainerView)->Void)? = nil) {
        updateFrames(percentage: 1.0, includeTop: false)
        UIView.animate(withDuration: fastAnimation ? fastAnimationDuration : slowAnimationDuration, animations: {
            var direction = target.center.x >= self.originalLocation.x ? 1.0 : -1.0
            var angle : CGFloat = 0.0
            var additional : CGFloat = 0.0
            // if it's an automated swipe then
            if self.originalLocation.y == 0.0 {
                // automated
                direction = 1.0
                angle = 0.7
                additional = -60.0
                target.transform = CGAffineTransform.init(rotationAngle: angle)
            }
            target.center = CGPoint(x: (UIScreen.main.bounds.width + UIScreen.main.bounds.height) * CGFloat(direction), y: target.center.y + additional)
            target.alpha = 0.0
        }) { (a) in
            DispatchQueue.main.async {
                self.view.sendSubview(toBack: target)
                            target.center = self.originalLocation
                            target.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.9)
                
                self.view.layoutSubviews()
                
                if let cb = completedCB {
                    cb(target)
                }

                self.updateFrames(percentage: 0.0, includeTop: true, animated: false)
                UIView.animate(withDuration: 0.1, animations: {
                    target.alpha = 1.0 - self.stackEffectOpacityStep*CGFloat(self.numberOfVisibleItems-1)
                })
            }

        }
    }
    
    func resetCard(target: GCStackItemContainerView, animated: Bool = true) {
        UIView.animate(withDuration: animated ? PlayRoundViewController.SWIPE_DRAG_ANIMATION_DURATION : 0) {
            target.transform = CGAffineTransform.identity
            target.center = self.originalLocation
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
