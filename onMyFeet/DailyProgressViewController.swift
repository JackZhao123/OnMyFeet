//
//  ProgressViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-22.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

struct dateFormat {
    var date: NSDate
    var year: Int
    var month: Int
    var day: Int
    
    init( date:NSDate, year:Int, month:Int, day:Int)
    {
        self.date = date
        self.year = year
        self.month = month
        self.day = day
    }
    
}

class DailyProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dataTableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    
    let fitbitAPI = FitbitAPI()
    var dailySummary: DailySummary?
    var currentDate: NSDate?
    let dataType = ["steps","distances","minutesActive","minutesLightlyActive","minutesSedentary","sleepTime"]
    var mDate : dateFormat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrentDate()

        //TimeLabel
        setDateLable()
        
        //TableView
        dataTableView.delegate = self
        dataTableView.dataSource = self
        getSummary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Date
    func getCurrentDate() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day], fromDate: date)
        let year = components.year
        let month = components.month
        let day = components.day
        
        mDate = dateFormat(date: date, year: year, month: month, day: day)
    }
    
    func setDateLable() {
        if let mDate = mDate{
            let lableText = String(format: "%d-%02d-%02d", mDate.year,mDate.month,mDate.day)
            
            timeLabel.text = lableText
        }
    }
    
    func increaseDate() {
        let calendar = NSCalendar.currentCalendar()
        let nextDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: 1, toDate: (mDate?.date)!, options: NSCalendarOptions(rawValue: 0))
        
        let components = calendar.components([.Year, .Month, .Day], fromDate: nextDate!)
        let year = components.year
        let month = components.month
        let day = components.day
        
        mDate = dateFormat(date: nextDate!, year: year, month: month, day: day)
    }
    
    @IBAction func nextDay(sender: AnyObject) {
        increaseDate()
        setDateLable()
        getSummary()
        dataTableView.reloadData()
    }
    
    func decreaseDate() {
        let calendar = NSCalendar.currentCalendar()
        let nextDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -1, toDate: (mDate?.date)!, options: NSCalendarOptions(rawValue: 0))
        
        let components = calendar.components([.Year, .Month, .Day], fromDate: nextDate!)
        let year = components.year
        let month = components.month
        let day = components.day
        
        mDate = dateFormat(date: nextDate!, year: year, month: month, day: day)
    }
    
    @IBAction func lastDay(sender: AnyObject) {
        decreaseDate()
        setDateLable()
        getSummary()
        dataTableView.reloadData()
        
//        DataCoordinator.sharedInstance.getIntradaySedentary()
        
//        if let intradaySedentary = ClientDataManager.sharedInstance().fetchDataOf("IntradaySedentary", parameter: ["dateTime"], argument: ["2016-03-02"]) as? [IntradaySedentary] {
//            for i in intradaySedentary {
//                print(i.dateTime)
//                print(i.time)
//                print(i.value)
//            }
//        }
        
        
//        DataCoordinator.sharedInstance.getIntradayData()
        
//        if let intradayData = ClientDataManager.sharedInstance().fetchSingleDaySleepWith("2016-03-02") {
//            for intraday in intradayData {
//                
//                print(intraday.dateTime)
//                print(intraday.time)
//                print(intraday.value)
//            }
//        }
    }
    
    
    //MARK: Get Data
    func getSummary(){
        let dateTime = timeLabel.text
        dailySummary = ClientDataManager.sharedInstance().fetchSummaryWith(dateTime!)
    }
    
    //MARK: Actions
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: TableView Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataType.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("summaryCell")
        
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "summaryCell")
        
        cell?.textLabel?.text = dataType[indexPath.row]
        let value = dailySummary?.valueForKey(dataType[indexPath.row])
        
        if let value = value {
            cell?.detailTextLabel?.text = "\(value)"
        } else {
            cell?.detailTextLabel?.text = "0"
        }
        return cell!
    }

}
