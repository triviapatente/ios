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
        
        let dataEntries = generateDataEntries(response: response)
        chartView.dataEntries = dataEntries
    
        self.chartView.isHidden = false
        
    }
    
    func generateDataEntries(response: TPStatsDetailResponse) -> [BarEntry] {
        var result: [BarEntry] = []
        
        guard !response.percentages.isEmpty else { return [] }
        let sorted = response.percentages.sorted { $0.key < $1.key }
        var maxValue = -1
        for element in response.percentages.values {
            if element.0 > maxValue {
                maxValue = element.0
            }
        }
        for (dateString, p) in sorted {
            let height: Float = Float(p.0) / Float(max(5, maxValue))
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            let date = dateString.dateFromISO8601
            let errors = p.0 - p.1
            
            // error string
            var errorString = "\(errors) " + (errors == 1 ? "errore" : "errori")
            if p.0 == 0 {
                errorString = ""
            }
            
            result.append(BarEntry(color: colorForDay(total: p.0, correct: p.1), height: height, textValue: "\(p.0)", title: formatter.string(from: date!), subtitle: errorString))
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
        let progressString = NSMutableAttributedString(string: "\(category.progress)%", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 20.0)!])
        progressString.append(NSMutableAttributedString(string: " su \(category.total_answers!) quiz affrontati", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Avenir Next", size: 14.0)!]))
        detailsLabel.attributedText = progressString
        self.detailsContainer.backgroundColor = category.status.color
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
