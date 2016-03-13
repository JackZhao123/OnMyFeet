//
//  SleepTimeCell.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-12.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class SleepTimeCell: UITableViewCell {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var sleepTimeData: [simpleSleepData]?
    let topMargin: CGFloat = 8.0
    let graphHeight: CGFloat = 300.0
    var titleLabel: UILabel!
    let graphWidth = {()->CGFloat in
        return UIScreen.mainScreen().bounds.width - 4*8
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: CGRect(x: 16.0, y: 8.0, width: screenWidth, height: 21))
        titleLabel.text = "Sleep Status"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        self.backgroundColor = .None
        if let sleepTimeData = sleepTimeData {
            if sleepTimeData.count > 0 {
                for index in 0...sleepTimeData.count - 1 {
                    let sleepChart = SleepChartView(frame: CGRect(x: 24, y: (8+200) * CGFloat(index) + 8 , width: screenWidth - 32, height: 200.0))
                    sleepChart.sleepValues = sleepTimeData[index].sleepValues
                    sleepChart.backgroundColor = UIColor.whiteColor()
                    self.contentView.addSubview(sleepChart)
                    self.contentView.addSubview(titleLabel)

                }
            }

        }
        
        
    }
}
