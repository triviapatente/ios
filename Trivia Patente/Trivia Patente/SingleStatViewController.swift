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

class SingleStatViewController: UIViewController, IAxisValueFormatter {
    @IBOutlet var chartView : LineChartView!
    @IBOutlet var descriptionLabel : UILabel!
    
    var errorsView : TPRecentView! {
        didSet {
            errorsView.cellNibName = "WrongAnswerTableViewCell"
            errorsView.rowHeight = 100
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
        configureChart()
    }
    func loadData() {
        let loadingView = MBProgressHUD.showAdded(to: self.view, animated: true)
        handler.category_stats(category: category) { response in
            loadingView.hide(animated: true)
            if response.success == true {
                self.populateViews(response: response)
            } else {
                //TODO: handle error
            }
        }
    }
    func populateViews(response : TPStatsDetailResponse) {
        self.response = response
        
        errorsView.items = response.wrong_answers
        
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
            var entries : [ChartDataEntry] = []
            var i = 0, currentValue = 0
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
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "errors_view" {
            self.errorsView = segue.destination as! TPRecentView
            self.errorsView.title = "Quiz sbagliati"
        }
    }

}
