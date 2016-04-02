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
        mTimePicker.datePickerMode = .Time
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
