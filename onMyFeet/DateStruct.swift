//
//  DateStruct.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

struct DateStruct {
    static let MonthDict = [
        "01":"Jan",
        "02":"Feb",
        "03":"Mar",
        "04":"Apr",
        "05":"May",
        "06":"Jun",
        "07":"Jul",
        "08":"Aug",
        "09":"Sept",
        "10":"Oct",
        "11":"Nov",
        "12":"Dec"
    ]
    
    static func dayMonthFormatFromDefault(dateTime:String) -> String{
        //input dateTime format YYYY-MM-DD to DD, MM (MAR JAN)
        let dateCom = dateTime.componentsSeparatedByString("-")
        let result = dateCom[2] + " " + DateStruct.MonthDict[dateCom[1]]!
        return result
    }
    
    static func getDateFromDefaultFormat(dateTime:String) -> NSDate? {
        //default dateTime format YYYY-MM-DD
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = NSCalendar.currentCalendar()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let date = formatter.dateFromString(dateTime)
        return date
    }
    
    static func getDateStringFromDate(date:NSDate) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = NSCalendar.currentCalendar()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let dateTime = formatter.stringFromDate(date)
        return dateTime
    }
    
    static func dateValueChangeFrom(dateTime:String, by interval:Int) -> String {
        let currentDate = getDateFromDefaultFormat(dateTime)
        let calendar = NSCalendar.currentCalendar()
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let resultDate = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: interval, toDate: currentDate!, options: NSCalendarOptions(rawValue: 0))
        let dateTime = getDateStringFromDate(resultDate!)
        
        return dateTime!
    }
    
    static func getCurrentDate() -> String {
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: date)
        let dateTime = String(format: "%d-%02d-%02d", components.year, components.month,components.day)
        print(dateTime)
        return dateTime
    }
    
    static func getWeekDay() -> [String]{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let components = NSCalendar.currentCalendar().components([.Year,.Month,.Day,.Weekday], fromDate: NSDate())
        let day = components.day
        let month = components.month
        let year = components.year
        let weekDay = components.weekday
        let todayDate = String(format:"%d-%02d-%02d", year,month,day)
        
        let firstDayOfWeek = dateValueChangeFrom(todayDate, by: -(weekDay-1))
        let lastDayOfWeek = dateValueChangeFrom(todayDate, by: 7-weekDay)
        
        return [firstDayOfWeek, lastDayOfWeek]
    }
    
}