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
    var itemNib : UINib?
    var contentInset : UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.reloadGraphics()
        }
    }
    var itemBackgroundColor : UIColor = UIColor.white {
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
        }
    }
    
    var lastElementSelected : Bool {
        get {
            return currentIndex == dataSource!.numberOfItems() - 1 // TODO
        }
    }
    
    private var stackEffectDeepDegreeFixed = CGFloat(6)
    private var stackEffectSqueezeDegreeFixed = CGFloat(6)
    private var stackEffectOpacityStep = CGFloat(0.15)
    
    var itemViews : [UIView] {
        get {
            return self.view.subviews
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        createVisibleViewContainers()
    }
    
    private func reloadGraphics() {
        self.createVisibleViewContainers()
    }
    
    private func createVisibleViewContainers() {
        // Create the views
        self.view.removeAllSubviews()
        for i in 0..<numberOfVisibleItems {
            let itemView = UIView()
            self.view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute:.bottom, multiplier: 1, constant: 0))
            
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .leadingMargin, relatedBy: .equal, toItem: self.view, attribute: .leadingMargin, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: itemView, attribute: .trailingMargin, relatedBy: .equal, toItem: self.view, attribute: .trailingMargin, multiplier: 1, constant: 0))
            self.customizeItemViewContainer(view: itemView)
            self.orderChanged()
        }
    }
    
    private func orderChanged() {
        guard self.itemViews.count == numberOfVisibleItems else { return }
        for i in 0..<numberOfVisibleItems {
            let iCompl = CGFloat(numberOfVisibleItems-1-i)
            let itemView = self.view.subviews[Int(i)]
            itemView.transform = CGAffineTransform.identity
            for c in self.view.constraints {
                if let v = c.firstItem as? UIView, v == itemView {
                    switch c.firstAttribute {
                    case .top: c.constant = contentInset.top + stackEffectDeepDegreeFixed * CGFloat(i)
                    case .bottom: c.constant = -(contentInset.bottom + stackEffectDeepDegreeFixed * iCompl)
                    case .leadingMargin: c.constant = contentInset.left + stackEffectSqueezeDegreeFixed*iCompl
                    case .trailingMargin: c.constant = -(contentInset.right+stackEffectSqueezeDegreeFixed*iCompl)
                    default: break
                    }
                }
                itemView.alpha = 1.0 - stackEffectOpacityStep*iCompl
            }
            itemView.gestureRecognizers!.first!.isEnabled = false
            if i == numberOfVisibleItems - 1 {
                itemView.gestureRecognizers!.first!.isEnabled = true
            }
        }
        checkRemaingItems()
    }
    
    private func customizeItemViewContainer(view: UIView) {
        view.mediumRounded()
//        view.backgroundColor = itemBackgroundColor
        view.backgroundColor = UIColor(red:   CGFloat(arc4random()) / CGFloat(UInt32.max),
                       green: CGFloat(arc4random()) / CGFloat(UInt32.max),
                       blue:  CGFloat(arc4random()) / CGFloat(UInt32.max),
                       alpha: 1.0)
        
        let cellPan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognized(gestureRecognizer:)))
        view.addGestureRecognizer(cellPan)

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
        
    }
    
    func scrollToNext() -> Bool {
        if !lastElementSelected
        {
            animateAway(target: getTopItemView()) {
                self.currentIndex = self.currentIndex + 1
                
            }
            return true
        }
        return false
    }
    
    private func checkRemaingItems() {
        let totalItems = dataSource!.numberOfItems()
        let toDisplayNext = totalItems - currentIndex
        for i in 0..<itemViews.count {
            self.itemViews[i].isHidden = toDisplayNext < numberOfVisibleItems - i
        }
    }
    
    func scrollTo(index: UInt, animated: Bool) {
        
    }
    
    
    // CARD animations
    var originalLocation : CGPoint = CGPoint.zero
    //conf
    var rotationMax = CGFloat(1.0)
    var defaultRotationAngle = CGFloat(1.0)
    var rotationStrength = CGFloat(1.0)
    var scaleMin = CGFloat(1.0)
    var animationDirection : CGFloat = 1.0
    var hasElementBehind = false
    var ausiliaryCopy : UIView?
    @IBAction func panGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let target = gestureRecognizer.view!
        let xDistanceFromCenter = gestureRecognizer.translation(in: target).x
        let yDistanceFromCenter = gestureRecognizer.translation(in: target).y
        
        let touchLocation = gestureRecognizer.location(in: target)
        switch gestureRecognizer.state {
        case .began:
            originalLocation = target.center
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
            let scaleTransform = transform.scaledBy(x: scale, y: scale)
            
            target.transform = scaleTransform
            target.center = CGPoint(x: originalLocation.x + xDistanceFromCenter, y: originalLocation.y + yDistanceFromCenter)
            updateSecondaryAnimations(percentage: xDistanceFromCenter / target.frame.size.width)
            
            break
        case .ended:
            panEnded(percentage: xDistanceFromCenter / target.frame.size.width, target: target)
            target.layer.shouldRasterize = false
        default :
            break
        }
    }
    
    private func updateSecondaryAnimations(percentage: CGFloat) {
        let completionPercentage = min(abs(percentage) / PlayRoundViewController.SWIPE_DRAG_PERCENTAGE, 1)
        for i in 0..<itemViews.count-1 {
            let itemView = itemViews[i]
            UIView.animate(withDuration: percentage == 0 ? PlayRoundViewController.SWIPE_DRAG_ANIMATION_DURATION : 0, animations: {
                itemView.alpha = 1.0 - self.stackEffectOpacityStep*CGFloat(self.numberOfVisibleItems-1-i) + self.stackEffectOpacityStep*completionPercentage
                //scale
                let scaleX = (self.stackEffectSqueezeDegreeFixed * 2 / itemView.frame.width)*completionPercentage  + 1
                let transormarion = CGAffineTransform(translationX: 0, y: self.stackEffectDeepDegreeFixed*completionPercentage)
                itemView.transform = transormarion.scaledBy(x: scaleX, y: 1)
            })
            
        }
    }
    
    private func getTopItemView() -> UIView {
        return self.view.subviews.last!
    }
    
    func panEnded(percentage: CGFloat, target: UIView)
    {
        if abs(percentage) > PlayRoundViewController.SWIPE_DRAG_PERCENTAGE {
            if !lastElementSelected {
                scrollToNext()
            } else {
                resetCard(target: target, animated: true)
                updateSecondaryAnimations(percentage: 0)
            }
        } else {
            resetCard(target: target, animated: true)
            updateSecondaryAnimations(percentage: 0)
        }
    }
    
    private func animateAway(target: UIView, completedCB: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            let direction = target.center.x > self.originalLocation.x ? 1.0 : -1.0
            target.center = CGPoint(x: self.originalLocation.x * CGFloat(3.5) *
                CGFloat(direction), y: target.center.y)
        }) { (a) in
            self.view.sendSubview(toBack: target)
            target.center = self.view.center
            target.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.9)
            self.resetCard(target: target, animated: true)
            if let cb = completedCB {
                cb()
            }
        }
    }
    
    func resetCard(target: UIView, animated: Bool = true) {
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
