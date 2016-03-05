//
//  WeeklyProgressViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class WeeklyProgressViewController: UIViewController,graphViewDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chartScrolView: UIScrollView!
    
    var graphCollection = [GraphView]()
    let graphTitle = ["Steps","Distances","MinutesSedentary","MinutesActive","MinutesLightlyActive"]
    
    var today: dateFormat!
    var firstDayOfWeek: dateFormat!
    var lastDayOfWeek: dateFormat!
    var weeklyData = [DailySummary?]()
    var dateArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getWeekDay()
        setLabelText()
        getWeeklyData()
        initGraphViews(200.0)
        
       
    }
    
    func initGraphViews(height: CGFloat) {
        
        for i in 0..<graphTitle.count {
            let graph = GraphView(frame: CGRect(x: 8, y: 4 + (4 + height) * CGFloat(i), width: UIScreen.mainScreen().bounds.width - 16, height: height))
            graph.delegate = self
            graph.backgroundColor = UIColor.whiteColor()
            graph.label.text = graphTitle[i]
            graph.tag = i
            graph.graphPoints = returnGraphData()[i]
            graph.dateArray = dateArray
            graph.currentDate = String(format: "%d-%02d-%02d", arguments: [today.year,today.month,today.day])
            self.chartScrolView.addSubview(graph)
            self.graphCollection.append(graph)
        }
        
        
        self.chartScrolView.contentSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: (height * CGFloat(graphTitle.count)) + 24)
    }
    
    func returnGraphData() -> [[Int]] {
        var steps = [Int]()
        var distances = [Int]()
        var minutesActive = [Int]()
        var minutesLightlyActive = [Int]()
        var minutesSedentary = [Int]()
        
        for i in 0..<7 {
            if let summary = weeklyData[i] {
                steps.append((summary.steps?.integerValue)!)
                distances.append((summary.distances?.integerValue)!)
                minutesActive.append((summary.minutesActive?.integerValue)!)
                minutesLightlyActive.append((summary.minutesLightlyActive?.integerValue)!)
                minutesSedentary.append((summary.minutesSedentary?.integerValue)!)
            } else {
                steps.append(0)
                distances.append(0)
                minutesActive.append(0)
                minutesLightlyActive.append(0)
                minutesSedentary.append(0)
                
            }
        }
        
        let data = [steps,distances,minutesSedentary,minutesActive,minutesLightlyActive]
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
    
    func redrawGraph() {
        for i in 0..<graphTitle.count {
            let graph = self.graphCollection[i]
            graph.graphPoints = returnGraphData()[i]
            graph.dateArray = dateArray
        }
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

    //MARK: Actions
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func lastWeek(sender: AnyObject) {
        lastDayOfWeek = getDateByInterval(-7, from: lastDayOfWeek.date)
        firstDayOfWeek = getDateByInterval(-7, from: firstDayOfWeek.date)
        setLabelText()
        getWeeklyData()
        redrawGraph()
    }
    
    @IBAction func nextWeek(sender: AnyObject) {
        lastDayOfWeek = getDateByInterval(7, from: lastDayOfWeek.date)
        firstDayOfWeek = getDateByInterval(7, from: firstDayOfWeek.date)
        setLabelText()
        getWeeklyData()
        redrawGraph()
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
