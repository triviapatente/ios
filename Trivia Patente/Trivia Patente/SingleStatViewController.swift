//
//  SingleStatViewController.swift
//  Trivia Patente
//
//  Created by Luigi Donadel on 11/11/16.
//  Copyright © 2016 Terpin e Donadel. All rights reserved.
//

import UIKit
import Charts
import MBProgressHUD
import BulletinBoard

class SingleStatViewController: TPNormalViewController, IAxisValueFormatter {
    @IBOutlet var chartView : LineChartView!
    @IBOutlet var descriptionLabel : UILabel!
    
    var fakeCell : WrongAnswerTableViewCell!
    var errorsView : TPExpandableView! {
        didSet {
            errorsView.cellNibName = "WrongAnswerTableViewCell"
            errorsView.rowHeight = 100
            errorsView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
            errorsView.DEAFULT_CONTAINER_TOP_SPACE = CGFloat(443)
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
        self.view.backgroundColor = category.status.color
        self.descriptionLabel.text = category.status.rawValue
        self.chartView.mediumRounded()
        //Se la categoria è complessivo, non li mostro
        self.errorsView.isHidden = category.isOverall
        
        configureChart()
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
        let data = LineChartData(dataSet: chartDataSet)
        chartView.data = data

    }
    func configureChart() {
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1, easingOption: .easeInOutBack)
        chartView.legend.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.chartDescription?.enabled = false
        configure(x: chartView.xAxis)
        configure(left: chartView.leftAxis)
        configure(right: chartView.rightAxis)
    }
    func configure(x : XAxis) {
        x.drawGridLinesEnabled = false
        x.labelPosition = .bottom
        x.valueFormatter = self
        x.labelTextColor = .lightGray
        x.labelRotationAngle = 60
    }
    func configure(left: YAxis) {
        left.axisMaximum = 101
        left.axisMinimum = 0
        left.labelCount = 10
        left.labelTextColor = .lightGray
        left.drawGridLinesEnabled = false
    }
    func configure(right : YAxis) {
        right.enabled = false
    }
    
    var chartDataEntries : [ChartDataEntry] {
        get {
            guard !response.percentages.isEmpty else { return [] }
            var entries : [ChartDataEntry] = []
            let sum = response.percentages.values.reduce(0) {$0 + $1}
            var i = 0, currentValue = category.progress - sum
            let progresses = response.percentages.sorted { (first, second) -> Bool in
                return first.key < second.key
            }
            for (_, value) in progresses {
                currentValue += value
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(currentValue))
                entries.append(dataEntry)
                i += 1
            }
            return entries
        }
    }
    var chartDataSet : LineChartDataSet {
        get {
            let dataSet = LineChartDataSet(values: chartDataEntries, label: "Progresso")
            dataSet.drawFilledEnabled = false
            dataSet.drawCirclesEnabled = false
            dataSet.mode = .linear
            dataSet.drawValuesEnabled = false
            dataSet.setColor(category.status.color)
            dataSet.fillColor = category.status.color
            return dataSet
        }
    }
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let keys = self.response.percentages.keys.sorted()
        let index = Int(value)
        if let date = keys[index].dateFromISO8601 {
            return self.dateFormatter.string(from: date)
        }
        return ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadData()
        let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 100)
        let nib = UINib(nibName: "WrongAnswerTableViewCell", bundle: Bundle.main)
        fakeCell = nib.instantiate(withOwner: self, options: nil)[0] as! WrongAnswerTableViewCell
        fakeCell.frame = frame
        
        errorsView.setTopBarLabelContent(string: "")
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "errors_view" {
            self.errorsView = segue.destination as! TPExpandableView
            self.errorsView.title = "Quiz sbagliati"
        }
    }

}
