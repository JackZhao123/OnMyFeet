//
//  WeekView.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-27.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import Charts

protocol WeekViewDelegate {
    func chartValueSelected(onDate: String)
}

class WeekView: UIView, ChartViewDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    //Label
    let dateLabel: UILabel! = UILabel()
    let rightBtn: UIButton! = UIButton(type: .System)
    let leftBtn: UIButton! = UIButton(type: .System)
    
    //Graph
    var mGraph:BarChartView!
    
    //DataModel
    var dataItem: DataItem?
    
    //Delegate
    var delegate: WeekViewDelegate?
    
    let yColor = UIColor(red: 0.925, green: 0.839, blue: 0.247, alpha: 1.00)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(item:DataItem) {
        self.init(frame:CGRect.zero)
        self.dataItem = item
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        self.backgroundColor = UIColor(red: 0.890, green: 0.890, blue: 0.890, alpha: 1.00)
        
        //Label
        let firstDay = DateStruct.dayMonthFormatFromDefault((dataItem?.firstDayOfWeek)!)
        let lastDay = DateStruct.dayMonthFormatFromDefault((dataItem?.lastDayOfWeek)!)
        dateLabel.text = firstDay + " - " + lastDay
        dateLabel.textColor = UIColor(red: 66/255.0, green: 67/255.0, blue: 70/255.0, alpha: 1.00)
        dateLabel.font = UIFont.systemFontOfSize(22.0)
        dateLabel.frame = CGRect(x: (screenWidth/2 - 100), y: 12, width: 200, height: 28)
        dateLabel.textAlignment = .Center
        self.addSubview(dateLabel)
        
        //Button
        let leftMargin = screenWidth/2 - 125
        let rightMargin = screenWidth/2 + 125 - 28
        
        leftBtn.setImage(UIImage(named: "left-arrow"), forState: .Normal)
        leftBtn.frame = CGRect(x: leftMargin, y: 12, width: 28, height: 28)
        leftBtn.tintColor = UIColor(red: 66/255.0, green: 67/255.0, blue: 70/255.0, alpha: 1.00)
        leftBtn.addTarget(self, action: #selector(WeekView.last), forControlEvents: .TouchUpInside)
        
        rightBtn.setImage(UIImage(named: "right-arrow"), forState: .Normal)
        rightBtn.frame = CGRect(x: rightMargin, y: 12, width: 28, height: 28)
        rightBtn.tintColor = UIColor(red: 66/255.0, green: 67/255.0, blue: 70/255.0, alpha: 1.00)
        rightBtn.addTarget(self, action: #selector(WeekView.next), forControlEvents: .TouchUpInside)

        self.addSubview(rightBtn)
        self.addSubview(leftBtn)
        
        //GraphView
        mGraph = BarChartView()
        mGraph.translatesAutoresizingMaskIntoConstraints = false
        configureView(mGraph)
        self.addSubview(mGraph)
        
        
        //Constraint
        let viewsDictionary = ["graph":mGraph]
        
        let graph_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[graph]-8-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let graph_control_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-44-[graph]-8-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(graph_control_constraint_H)
        self.addConstraints(graph_control_constraint_V)
        
        reloadChart()
    }
    
    func configureView(chartView: BarLineChartViewBase) {
        chartView.rightAxis.enabled = false
        chartView.leftAxis.customAxisMin = 0.0
        chartView.rightAxis.customAxisMin = 0.0
        chartView.notifyDataSetChanged()
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.xAxis.setLabelsToSkip(0)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .Bottom
        chartView.descriptionText = ""
        chartView.delegate = self
        
        chartView.animate(yAxisDuration: 1.5)
    }
    
    func reloadChart() {
        //Configure Chart Data
        let weekDay = ["Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"]
        var data:[Double] = [0,0,0,0,0,0,0]
        
        
        
        if let dataItem = dataItem {
            data = dataItem.weeklyData
            if dataItem.title == "Intensity" {
                
                var yVals = [BarChartDataEntry]()
                for i in 0..<data.count {
                    let val1 = data[i] / 1440
                    let val2 = dataItem.weeklyLightly[i] / 1440
                    let val3 = dataItem.weeklyActive[i] / 1440
                    
                    let entry = BarChartDataEntry(values: [val1,val2,val3], xIndex: i)
                    yVals.append(entry)
                }
                
                let chartDataSet = BarChartDataSet(yVals: yVals, label: "Intensity")
                chartDataSet.colors = [UIColor(red: 1.000, green: 0.506, blue: 0.588, alpha: 1.00),UIColor(red: 0.925, green: 0.839, blue: 0.247, alpha: 1.00),UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)]
                chartDataSet.stackLabels = ["Sedentary","Lightly","Active"]
                chartDataSet.drawValuesEnabled = false
                
                let chartData = BarChartData(xVals: weekDay, dataSet: chartDataSet)
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .PercentStyle

                mGraph.data = chartData
                mGraph.leftAxis.valueFormatter = formatter
            } else {
                var dataEntries: [BarChartDataEntry] = []
                
                for i in 0..<data.count {
                    let dataEntry = BarChartDataEntry(value: data[i], xIndex: i)
                    dataEntries.append(dataEntry)
                }
                
                let chartDataSet = BarChartDataSet(yVals: dataEntries, label: dataItem.title)
                chartDataSet.colors = [UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)]
                let chartData = BarChartData(xVals: weekDay, dataSet: chartDataSet)
                
                mGraph.data = chartData
                mGraph.drawValueAboveBarEnabled = true
                
                let formatter = NSNumberFormatter()
                formatter.numberStyle = .DecimalStyle
                
                mGraph.leftAxis.valueFormatter = formatter
            }
        }
    }
    
    func next(){
        
        let firstDate = dataItem!.firstDayOfWeek
        let lastDate = dataItem!.lastDayOfWeek
        
        dataItem!.firstDayOfWeek = DateStruct.dateValueChangeFrom(firstDate, by: 7)
        dataItem!.lastDayOfWeek = DateStruct.dateValueChangeFrom(lastDate, by: 7)
        
        let firstDay = DateStruct.dayMonthFormatFromDefault((dataItem?.firstDayOfWeek)!)
        let lastDay = DateStruct.dayMonthFormatFromDefault((dataItem?.lastDayOfWeek)!)
        dataItem?.getWeeklyData()
        reloadChart()
        
        dateLabel.text = firstDay + " - " + lastDay
    }
    
    func last(){
        let firstDate = dataItem!.firstDayOfWeek
        let lastDate = dataItem!.lastDayOfWeek
        dataItem!.firstDayOfWeek = DateStruct.dateValueChangeFrom(firstDate, by: -7)
        dataItem!.lastDayOfWeek = DateStruct.dateValueChangeFrom(lastDate, by: -7)
        
        let firstDay = DateStruct.dayMonthFormatFromDefault((dataItem?.firstDayOfWeek)!)
        let lastDay = DateStruct.dayMonthFormatFromDefault((dataItem?.lastDayOfWeek)!)
        
        dataItem?.getWeeklyData()
        reloadChart()
        
        dateLabel.text = firstDay + " - " + lastDay
    }
    
    //MARK: Chart View Delegate
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {

        if let dataItem = dataItem {
            let selectedDate = DateStruct.dateValueChangeFrom(dataItem.firstDayOfWeek, by: entry.xIndex)
            if let delegate = delegate {
                delegate.chartValueSelected(selectedDate)
            }
        }
    }
}
