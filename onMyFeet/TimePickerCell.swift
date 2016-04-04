//
//  TimePickerCell.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell {
    
    @IBOutlet weak var mTimePicker: UIDatePicker!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mTimePicker.date = NSDate()
        mTimePicker.datePickerMode = .Time
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func getCurrentDisplayTime() -> String{
        let calendar = NSCalendar.currentCalendar()
        let timeZone = calendar.timeZone
        let offset = timeZone.secondsFromGMT / 3600
        let offString = String(format: "%03d:00", offset)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.stringFromDate(mTimePicker.date)
        let dateString = "\(date)\(offString)"
        return dateString
    }
}
