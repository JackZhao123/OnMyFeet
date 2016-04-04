//
//  AlarmCell.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    var alarmId: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        alarmSwitch.addTarget(self, action: #selector(AlarmCell.valueChanged), forControlEvents: .ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func valueChanged(){
        if let alarmId = alarmId {
            let alarm = ClientDataManager.sharedInstance().fetchDataOf("Alarm", parameter: ["id"], argument: [alarmId]) as? [Alarm]
            if let alarm = alarm {
                for a in alarm {
                    
                    a.on = alarmSwitch.on
                    ClientDataManager.sharedInstance().saveContext()
                }
            }
        }
    }
    
}
