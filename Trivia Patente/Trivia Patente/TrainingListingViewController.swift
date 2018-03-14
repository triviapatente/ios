//
//  TrainingListingViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit

class TrainingListingViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var newQuizButton: UIButton!
    
    @IBOutlet weak var proportionalBarContainer: UIView!
    @IBOutlet var bottomBarCostraint : [NSLayoutConstraint]!
    @IBOutlet var waveStatsLabel : [UILabel]!
    @IBOutlet var collectionView : UIView!
    @IBOutlet var emptyListLabel : UILabel!
    
    var temporaryDataset = [1, 0, 2, 5, 3, 3, 2, 3, 1, 6, 15, 0, 2, 3, 2, 3, 1, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefaultBackgroundGradient()
        self.newQuizButton.mediumRounded()
        
        
        self.loadStats(values: [12, 2, 4, 10])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadStats(values: [UInt])
    {
        self.loadProportionalBar(values: values)
        self.loadExplicativeStats(values: values)
    }
    private func loadExplicativeStats(values: [UInt])
    {
        for i in 0..<self.bottomBarCostraint.count {
            self.waveStatsLabel[i].text = "\(values[i])"
        }
    }
    private func loadProportionalBar(values: [UInt])
    {
        let total = CGFloat(values.reduce(0, +))
        for c in 0..<self.bottomBarCostraint.count {
            self.bottomBarCostraint[c].constant = CGFloat(values[c]) / total * UIScreen.main.bounds.width
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "quiz_details", let destination = segue.destination as? QuizDetailsViewController {
            destination.loadItem(item: sender as! Int)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        self.emptyListLabel.isHidden = self.temporaryDataset.count != 0
        return self.temporaryDataset.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quiz_cell", for: indexPath) as! TrainingQuizCollectionViewCell
        cell.setItem(value: self.temporaryDataset[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                viewForSupplementaryElementOfKind kind: String,
                                at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,withReuseIdentifier: "mainHeader", for: indexPath)
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "quiz_details", sender: self.temporaryDataset[indexPath.row])
    }

}
