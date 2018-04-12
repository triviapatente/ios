//
//  SingleStatViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import MBProgressHUD
import BulletinBoard

class SingleStatViewController: TPNormalViewController {
    @IBOutlet var chartView : BeautifulBarChart!
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet weak var detailsContainer: UIView!
    
    @IBOutlet weak var detailsLabel: UILabel!
    var fakeCell : WrongAnswerTableViewCell!
    var errorsView : TPExpandableView! {
        didSet {
            errorsView.cellNibName = "WrongAnswerTableViewCell"
            errorsView.rowHeight = 100
            errorsView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            errorsView.DEAFULT_CONTAINER_TOP_SPACE = CGFloat(450)
            errorsView.cellSelectedCallback = { (quiz: Quiz) in
                self.showItemDetails(quiz: quiz)
            }
        }
    }
    // TODO: THIS CODE IS DUPLICATED IN ROUNDEDETAILS
    // expanding single question
    var quizDetailsBulletin : BulletinManager?
    internal func showItemDetails(quiz: Quiz) {
        let page = PageBulletinItem(title: "")
        page.interfaceFactory.tintColor = Colors.primary
        page.interfaceFactory.actionButtonTitleColor = .white
        page.shouldCompactDescriptionText = true
        let imageLoader =  UIImageView()
        imageLoader.load(quiz: quiz)
        page.image = imageLoader.image
        
        page.descriptionText = quiz.question
        
        let tapper = UITapGestureRecognizer(target: self, action: #selector(dismissBulletin))
        
        
        quizDetailsBulletin = BulletinManager(rootItem: page)
        
        quizDetailsBulletin!.prepare()
        quizDetailsBulletin!.presentBulletin(above: self)
        quizDetailsBulletin!.controller().view.addGestureRecognizer(tapper)
    }
    
    func dismissBulletin() {
        if let manager = self.quizDetailsBulletin {
            manager.dismissBulletin(animated: true)
        }
    }
    var category : Category!
    var response : TPStatsDetailResponse!
    var dateFormatter : DateFormatter {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM"
            return formatter
        }
    }
    
    let handler = HTTPStats()
    
    func setupView() {
        self.descriptionLabel.text = category.status.rawValue
        self.chartView.smallRounded()
    
        //Se la categoria è complessivo, non li mostro
        self.errorsView.isHidden = category.isOverall
    }
    func loadData() {
        let loadingView = MBProgressHUD.clearAndShow(to: self.view, animated: true)
        handler.category_stats(category: category) { response in
            loadingView.hide(animated: true)
            if response.success == true {
                self.populateViews(response: response)
            } else {
                self.handleGenericError(message: response.message, dismiss: true, traslateUp: false)
            }
        }
    }
    func populateViews(response : TPStatsDetailResponse) {
        self.response = response
        if !category.isOverall {
            errorsView.items = response.wrong_answers
        }
        
        let dataEntries = generateDataEntries()
        chartView.dataEntries = dataEntries
    
        self.chartView.isHidden = false
        
    }
    
    func generateDataEntries() -> [BarEntry] {
        var result: [BarEntry] = []
        
//        guard !response.percentages.isEmpty else { return [] }
        for i in 0..<20 {
            let value1 = (arc4random() % 90) + 10
            let value2 = (arc4random() % 90) + 10
            let height: Float = Float(max(value1, value2)) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(BarEntry(color: colorForDay(total: Int(max(value1, value2)), correct: Int(min(value1, value2))), height: height, textValue: "\(Int(max(value1, value2)))", title: formatter.string(from: date)))
        }
        return result
    }
    
    func colorForDay(total: Int, correct: Int) -> UIColor {
        let perc = Double(correct).divided(by: Double(total))
        if perc <= 0.25 {
            return Colors.stats_bad
        } else if perc <= 0.5 {
            return Colors.stats_medium
        } else if perc <= 0.75 {
            return Colors.stats_good
        } else {
            return Colors.stats_perfect
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        self.detailsContainer.mediumRounded()
        self.setDefaultBackgroundGradient()
        self.chartView.chartStartsAtEnd = true 
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 100)
        let nib = UINib(nibName: "WrongAnswerTableViewCell", bundle: Bundle.main)
        fakeCell = nib.instantiate(withOwner: self, options: nil)[0] as! WrongAnswerTableViewCell
        fakeCell.frame = frame
        
        errorsView.setTopBarLabelContent(string: "")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = self.category.name
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "errors_view" {
            self.errorsView = segue.destination as! TPExpandableView
            self.errorsView.title = "Quiz sbagliati"
            self.errorsView.emptyTitleText = "Nessun quiz sbagliato"
        }
    }

}
