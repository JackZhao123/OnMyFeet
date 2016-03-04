//
//  WeeklyProgressViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class WeeklyProgressViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chartScrolView: UIScrollView!
    
    
    var today: dateFormat!
    var firstDayOfWeek: dateFormat!
    var lastDayOfWeek: dateFormat!
    var weeklyData = [DailySummary?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        
        chartScrolView.contentSize = CGSize(width: chartScrolView.frame.width, height: 1000)
        
        getWeekDay()
        setLabelText()
        
        getWeeklyData()
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
        
//        var startDate = firstDayOfWeek
//        let formatter = NSDateFormatter()
//        var dateString: String!
//        formatter.dateFormat = "yyyy-MM-dd"
//        
//        for _ in 1...7 {
//            dateString = formatter.stringFromDate(startDate.date)
//            let summary = ClientDataManager.sharedInstance().fetchSummaryWith(dateString)
//            
//            
//            startDate = getDateByInterval(1, from: startDate.date)
//        }
        
    }

    //MARK: Actions
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func lastWeek(sender: AnyObject) {
        lastDayOfWeek = getDateByInterval(-7, from: lastDayOfWeek.date)
        firstDayOfWeek = getDateByInterval(-7, from: firstDayOfWeek.date)
        setLabelText()
    }
    
    @IBAction func nextWeek(sender: AnyObject) {
        lastDayOfWeek = getDateByInterval(7, from: lastDayOfWeek.date)
        firstDayOfWeek = getDateByInterval(7, from: firstDayOfWeek.date)
        setLabelText()
    }
}
