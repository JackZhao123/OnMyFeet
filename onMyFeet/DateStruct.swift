//
//  DateStruct.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

struct DateStruct {
    
    static func getCurrentCalendar() -> Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }
    
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
    
    static func dayMonthFormatFromDefault(_ dateTime:String) -> String{
        //input dateTime format YYYY-MM-DD to DD, MM (MAR JAN)
        let dateCom = dateTime.components(separatedBy: "-")
        let result = dateCom[2] + " " + DateStruct.MonthDict[dateCom[1]]!
        return result
    }
    
    static func getDateFromDefaultFormat(_ dateTime:String) -> Date? {
        //default dateTime format YYYY-MM-DD
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = formatter.date(from: dateTime)
        return date
    }
    
    static func getDateStringFromDate(_ date:Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let dateTime = formatter.string(from: date)
        return dateTime
    }
    
    static func dateValueChangeFrom(_ dateTime:String, by interval:Int) -> String {
        let currentDate = getDateFromDefaultFormat(dateTime)
        let resultDate = (getCurrentCalendar() as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: interval, to: currentDate!, options: NSCalendar.Options(rawValue: 0))
        let dateTime = getDateStringFromDate(resultDate!)
        
        return dateTime!
    }
    
    static func getCurrentDate() -> String {
        let date = Date()
        let components = (Calendar.current as NSCalendar).components([.year, .month, .day], from: date)
        let dateTime = String(format: "%d-%02d-%02d", components.year!, components.month!,components.day!)
        print(dateTime)
        return dateTime
    }
    
    static func getWeekDay() -> [String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let components = (getCurrentCalendar() as NSCalendar).components([.year,.month,.day,.weekday], from: Date())
        let day = components.day
        let month = components.month
        let year = components.year
        let weekDay = components.weekday
        let todayDate = String(format:"%d-%02d-%02d", year!,month!,day!)
        
        let firstDayOfWeek = dateValueChangeFrom(todayDate, by: -(weekDay!-1))
        let lastDayOfWeek = dateValueChangeFrom(todayDate, by: 7-weekDay!)
        
        return [firstDayOfWeek, lastDayOfWeek]
    }
    
    static func compare(_ startDate:String, with endDate:String) -> Double {
        let date1 = getDateFromDefaultFormat(startDate)
        let date2 = getDateFromDefaultFormat(endDate)
        
        let interval = date1!.timeIntervalSince(date2!) as Double
        return interval
    }
    
}
