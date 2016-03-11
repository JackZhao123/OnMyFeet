//
//  WeeklyProgressViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import Charts

class WeeklyProgressViewController: UIViewController,graphViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chartScrolView: UIScrollView!
    
    let graphTitle = ["Steps","Distances","MinutesSedentary","MinutesActive","MinutesLightlyActive","SleepTime"]
    
    var today: dateFormat!
    var firstDayOfWeek: dateFormat!
    var lastDayOfWeek: dateFormat!
    var weeklyData = [DailySummary?]()
    var dateArray = [String]()
    
    var stepChart:BarChartView!
    var distanceChart: LineChartView!
    var intensityChart: BarChartView!
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let chartHeight:CGFloat = 200.0
    let weekDay = ["Mon", "Tue", "Wed", "Thurs", "Fri", "Sat", "Sun"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeekDay()
        setLabelText()
        getWeeklyData()
        
        initStepsChart()
        self.chartScrolView.contentSize = CGSize(width: screenWidth, height: 3 * (chartHeight + 8))
    }
    
    func initStepsChart() {
        stepChart = BarChartView(frame: CGRect(x: 8, y: 4, width: screenWidth - 16 , height: chartHeight ))
        distanceChart = LineChartView(frame: CGRect(x: 8, y: 8 + chartHeight, width: screenWidth - 16 , height: chartHeight ))
        intensityChart = BarChartView(frame: CGRect(x: 8, y: 16 + 2 * chartHeight, width: screenWidth - 16 , height: chartHeight ))
        
        populateChartData()
        
        configureView(stepChart)
        configureView(distanceChart)
        configureView(intensityChart)
        
    }
    
    func configureView(chartView: BarLineChartViewBase) {
        chartView.rightAxis.enabled = false
        chartView.leftAxis.customAxisMin = 0.0
        chartView.rightAxis.customAxisMin = 0.0
        chartView.notifyDataSetChanged()
        
        chartView.xAxis.setLabelsToSkip(0)
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelPosition = .Bottom
        chartView.descriptionText = ""
        chartView.userInteractionEnabled = false
        
        self.chartScrolView.addSubview(chartView)
    }
    
    func populateChartData() {
        let steps = returnGraphData()[0]
        let distance = returnGraphData()[1]
        let sedentary = returnGraphData()[2]
        let active = returnGraphData()[3]
        let lightly = returnGraphData()[4]
        
        var dataEntries: [BarChartDataEntry] = []
        var distanceEntries: [ChartDataEntry] = []
        var sedentaryEntries: [BarChartDataEntry] = []
        var activeEntries: [BarChartDataEntry] = []
        var lightlyEntries: [BarChartDataEntry] = []
        
        for i in 0..<steps.count {
            let dataEntry = BarChartDataEntry(value: steps[i] , xIndex: i)
            dataEntries.append(dataEntry)
            
            let sedentaryEntry = BarChartDataEntry(value: sedentary[i], xIndex: i)
            sedentaryEntries.append(sedentaryEntry)
            
            let activeEntry = BarChartDataEntry(value: active[i], xIndex: i)
            activeEntries.append(activeEntry)
            
            let lightlyEntry = BarChartDataEntry(value: lightly[i], xIndex: i)
            lightlyEntries.append(lightlyEntry)
            
            let distanceEntry = ChartDataEntry(value: distance[i], xIndex: i)
            distanceEntries.append(distanceEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Steps")
        let chartData = BarChartData(xVals: weekDay, dataSet: chartDataSet)
        
        let lineDataSet = LineChartDataSet(yVals: distanceEntries, label: "Distance (meters)")
        let lineData = LineChartData(xVals: weekDay, dataSet: lineDataSet)
        
        let sedentaryDataSet = BarChartDataSet(yVals: sedentaryEntries, label: "sedentary")
        sedentaryDataSet.colors = [UIColor.redColor()]
        
        let activeDataSet = BarChartDataSet(yVals: activeEntries, label: "active")
        activeDataSet.colors = [UIColor.greenColor()]
        
        let lightlyDataSet = BarChartDataSet(yVals: lightlyEntries, label: "lightly")
        lightlyDataSet.colors = [UIColor.yellowColor()]
        
        let intensityData = BarChartData(xVals: weekDay, dataSets: [sedentaryDataSet,lightlyDataSet,activeDataSet])

        
        stepChart.data = chartData
        distanceChart.data = lineData
        intensityChart.data = intensityData
    }
    
    //MARK: GetData
    func returnGraphData() -> [[Double]] {
        var steps = [Double]()
        var distances = [Double]()
        var minutesActive = [Double]()
        var minutesLightlyActive = [Double]()
        var minutesSedentary = [Double]()
        var sleepTime = [Double]()
        
        for i in 0..<7 {
            if let summary = weeklyData[i] {
                steps.append((summary.steps?.doubleValue)!)
                distances.append((summary.distances?.doubleValue)! * 1000.0)
                minutesActive.append((summary.minutesActive?.doubleValue)!)
                minutesLightlyActive.append((summary.minutesLightlyActive?.doubleValue)!)
                minutesSedentary.append((summary.minutesSedentary?.doubleValue)!)
                sleepTime.append((summary.sleepTime?.doubleValue)!)
            } else {
                steps.append(0.0)
                distances.append(0)
                minutesActive.append(0)
                minutesLightlyActive.append(0)
                minutesSedentary.append(0)
                sleepTime.append(0)
            }
        }
        
        let data = [steps,distances,minutesSedentary,minutesActive,minutesLightlyActive,sleepTime]
        return data
    }
    
    func getDateText() -> [String]{
        var date = [String]()
        
        for i in 0..<7 {
            if let summary = weeklyData[i] {
                date.append(summary.dateTime!)
            }
        }
        
        return date
    }
    
    func getWeekDay() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let components = NSCalendar.currentCalendar().components([.Year,.Month,.Day,.Weekday], fromDate: NSDate())
        let day = components.day
        let month = components.month
        let year = components.year
        let weekDay = components.weekday
        let todayDate = formatter.dateFromString(String(format:"%d-%02d-%02d", year,month,day))
        today = dateFormat(date: todayDate!, year: year, month: month, day: day)
        
        lastDayOfWeek = getDateByInterval(7-weekDay, from: today.date)
        firstDayOfWeek = getDateByInterval(-(weekDay-1), from: today.date)
    }
    
    func getDateByInterval(value:Int, from date:NSDate) -> dateFormat {
        let calendar = NSCalendar.currentCalendar()
        let nextDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: value, toDate: date, options: NSCalendarOptions(rawValue: 0))
        
        let components = calendar.components([.Year, .Month, .Day], fromDate: nextDate!)
        let year = components.year
        let month = components.month
        let day = components.day
        let target = dateFormat(date: nextDate!, year: year, month: month, day: day)
        return target
        
    }
    
    func setLabelText() {
        let labelText = String(format: "%02d-%02d to %02d-%02d", arguments: [(firstDayOfWeek.month),(firstDayOfWeek?.day)!,(lastDayOfWeek.month),(lastDayOfWeek.day)])
        self.dateLabel.text = labelText
    }
    
    func getWeeklyData() {
        
        var startDate = firstDayOfWeek
        let formatter = NSDateFormatter()
        var dateString: String!
        formatter.dateFormat = "yyyy-MM-dd"
        weeklyData.removeAll()
        dateArray.removeAll()
        
        for _ in 1...7 {
            dateString = formatter.stringFromDate(startDate.date)
            dateArray.append(dateString)
            let summary = ClientDataManager.sharedInstance().fetchSummaryWith(dateString)
            weeklyData.append(summary)
            startDate = getDateByInterval(1, from: startDate.date)
        }
        
    }
    
    //    func initGraphViews(height: CGFloat) {
    //
    //        for i in 0..<graphTitle.count {
    //            let graph = GraphView(frame: CGRect(x: 8, y: 4 + (4 + height) * CGFloat(i), width: UIScreen.mainScreen().bounds.width - 16, height: height))
    //            graph.delegate = self
    //            graph.backgroundColor = UIColor.whiteColor()
    //            graph.label.text = graphTitle[i]
    //            graph.tag = i
    //            graph.graphPoints = returnGraphData()[i]
    //            graph.dateArray = dateArray
    //            graph.currentDate = String(format: "%d-%02d-%02d", arguments: [today.year,today.month,today.day])
    //            self.chartScrolView.addSubview(graph)
    //            self.graphCollection.append(graph)
    //        }
    //
    //
    //        self.chartScrolView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: (height * CGFloat(graphTitle.count)) + 24)
    //    }

    //MARK: Actions
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func lastWeek(sender: AnyObject) {
        lastDayOfWeek = getDateByInterval(-7, from: lastDayOfWeek.date)
        firstDayOfWeek = getDateByInterval(-7, from: firstDayOfWeek.date)
        setLabelText()
        getWeeklyData()
        populateChartData()
    }
    
    @IBAction func nextWeek(sender: AnyObject) {
        lastDayOfWeek = getDateByInterval(7, from: lastDayOfWeek.date)
        firstDayOfWeek = getDateByInterval(7, from: firstDayOfWeek.date)
        setLabelText()
        getWeeklyData()
        populateChartData()
    }
    
    func handleTap(sender: GraphView) {

        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailController") as! detailGraphController
        desController.graphTitle = sender.label.text
        desController.dateArray = sender.dateArray
        desController.graphPoints = sender.graphPoints
        desController.category = graphTitle[sender.tag]
        self.navigationController?.pushViewController(desController, animated: true)
        
    }
    
}
