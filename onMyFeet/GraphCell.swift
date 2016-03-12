//
//  GraphCell.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-12.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import Charts

class GraphCell: UITableViewCell {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var titleLabel:UILabel!
    var chartHeight:CGFloat = 200.0
    var chartData: [Double]? = [20.0,40.0,50.0]
    var pieChart:PieChartView?
    let sedentartColor = UIColor(red: 255/255.0, green: 128/255.0, blue: 150/255.0, alpha: 1.0)
    let activeColor = UIColor(red: 139/255.0, green: 195/255.0, blue: 74/255.0, alpha: 1.0)
    let lightlyColor = UIColor(red: 255/255.0, green: 212/255.0, blue: 132/255.0, alpha: 1.0)
    var typeArray = ["Sedentary","Lightly","Active"]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel(frame: CGRect(x: 16.0, y: 8.0, width: screenWidth, height: 21))
        titleLabel.text = ""
    }
    
    override func drawRect(rect: CGRect) {
        if let chartData = chartData {
            var dataEntries:[ChartDataEntry] = []
            var xTypeArray = [String]()
            
            for index in 0...chartData.count - 1 {
                
                if chartData[index] != 0 {
                    let entry = ChartDataEntry(value: chartData[index], xIndex: index)
                    dataEntries.append(entry)
                    xTypeArray.append(typeArray[index])
                }
            }
            
            if xTypeArray.count > 0{
                pieChart = PieChartView(frame: CGRect(x: 24, y: 29, width: screenWidth - 24 - 8, height: 300))
                
                let sedentaryDataSet = PieChartDataSet(yVals: dataEntries, label: "(minutes)")
                sedentaryDataSet.colors = [sedentartColor, lightlyColor, activeColor]
                
                let chartData = PieChartData(xVals: xTypeArray, dataSet: sedentaryDataSet)
                pieChart?.drawSliceTextEnabled = false
                
                pieChart?.descriptionText = ""
                pieChart?.data = chartData
                pieChart?.legend.position = .LeftOfChart
                self.contentView.addSubview(pieChart!)
                self.contentView.addSubview(titleLabel)
            } else {
                self.detailTextLabel?.text = "Data not Available"
            }
            
        }
    }
    
    override func awakeFromNib() {
        print("Awaking from nib")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
