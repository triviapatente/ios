//
//  TrainingListingViewController.swift
//  Trivia Patente
//
//  Created by Gabriel Ciulei on 08/03/2018.
//  Copyright © 2018 Terpin e Donadel. All rights reserved.
//

import UIKit
import BulletinBoard

class TrainingListingViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, TrainingQuizViewControllerDelegate {

    @IBOutlet weak var newQuizButton: UIButton!
    
    @IBOutlet weak var proportionalBarContainer: UIView!
    @IBOutlet var bottomBarCostraint : [NSLayoutConstraint]!
    @IBOutlet var waveStatsLabel : [UILabel]!
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var emptyListLabel : UILabel!

    let httpTraining = HTTPTraining()
    
    var trainings : [Training]?
    var summaryStats : TrainingStats? = MainViewController.trainings_stats
    
    lazy var bulletinManager: BulletinManager = {
        let page = ChooserBulletinItem(title: "Nuovo questionario")
        
        page.descriptionText = "Vuoi un questionario personalizzato in base alle tue precedenti prestazioni oppure casuale?"
        page.actionButtonTitle = "Chiudi"
        page.alternativeButtonTitle = ["Questionario personalizzato", "Questionario casuale"]
        
        page.alternativeHandler = { (button: UIButton, index: Int) in
            page.manager!.dismissBulletin()
            self.performSegue(withIdentifier: "quiz_view", sender: index == 0)
        }
        
        page.actionHandler = { (bulletin: ChooserBulletinItem) in
            bulletin.manager!.dismissBulletin()
        }
        
        return BulletinManager(rootItem: page)
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDefaultBackgroundGradient()
        self.newQuizButton.mediumRounded()
        
        self.collectionView.alwaysBounceVertical = true
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.white
        refresher.addTarget(self, action: #selector(refreshData), for: UIControlEvents.valueChanged)
        self.collectionView.refreshControl = refresher
//        self.collectionView.addSubview(refresher)
        
        
        self.loadStats()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        httpTraining.list_trainings { (response) in
            self.collectionView.refreshControl!.endRefreshing()
            if response.success == true {
                // stats
                if let stats = response.stats {
                    self.summaryStats = stats
                    MainViewController.trainings_stats = self.summaryStats
                    self.loadStats()
                }
                // trainings
                self.trainings = response.trainings.sorted(by: { (a, b) -> Bool in
                    return a.createdAt! > b.createdAt!
                })
                self.collectionView.reloadData()
            } else {
                self.handleGenericError(message: response.message, dismiss: true)
            }
        }
    }
    
    @IBAction func startNewTest() {
        bulletinManager.prepare()
        bulletinManager.presentBulletin(above: self)
    }
    
    func loadStats()
    {
        if let stats = summaryStats {
            let values : [Int32] = [stats.correct, stats.errors1_2, stats.errors3_4, stats.moreErrors]
            self.loadProportionalBar(total: stats.total, values: values)
            self.loadExplicativeStats(values: values)
        }
    }
    private func loadExplicativeStats(values: [Int32])
    {
        for i in 0..<self.bottomBarCostraint.count {
            self.waveStatsLabel[i].text = "\(values[i])"
        }
    }
    private func loadProportionalBar(total: Int32, values: [Int32])
    {
        guard total != 0 else { return }
        for c in 0..<self.bottomBarCostraint.count {
            self.bottomBarCostraint[c].constant = CGFloat(values[c]) / CGFloat(total) * UIScreen.main.bounds.width
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
            destination.item = sender as? Training
        } else if segue.identifier == "quiz_view", let destination = segue.destination as? TrainingQuizViewController {
            destination.randomQuestions = sender as! Bool
            destination.delegate = self
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard trainings != nil else {
            self.emptyListLabel.isHidden = false
            self.emptyListLabel.text = "Caricamento.."
            return 0
        }
        self.emptyListLabel.text = Strings.no_trainings_mesage
        self.emptyListLabel.isHidden = self.trainings!.count != 0
        return self.trainings!.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quiz_cell", for: indexPath) as! TrainingQuizCollectionViewCell
        cell.item = self.trainings![indexPath.row]
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
        return UICollectionReusableView()
    }
    public func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "quiz_details", sender: self.trainings![indexPath.row])
    }
    
    func saveTraining(training: Training, addToList: Bool) {
        print("To save")
    }

}
