//
//  SleepChartView.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-12.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

@IBDesignable class SleepChartView: UIView {
    @IBInspectable var sleepColor:UIColor = UIColor(red: 0.149, green: 0.282, blue: 0.475, alpha: 0.8)
    @IBInspectable var awakeColor:UIColor = UIColor(red: 1.000, green: 0.000, blue: 0.498, alpha: 1.00)
    @IBInspectable var restlessColor:UIColor = UIColor(red: 0.247, green: 0.514, blue: 1.000, alpha: 1.00)
    var labelHeightPercent:CGFloat = 0.08
    
    var startTime = "23:55:55"
    var endTime = "08:00:00"
    var sleepValues = [2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawRect(rect: CGRect) {
        let height = rect.size.height
        let width = rect.size.width
        let margin:CGFloat = 4
        let labelHeight = height * labelHeightPercent
        let fontPer:CGFloat = 0.07
        
        let linePath = UIBezierPath()
        linePath.moveToPoint(CGPoint(x: margin, y: height * 0.3))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height * 0.3))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - labelHeight))
        linePath.addLineToPoint(CGPoint(x: margin, y: height - labelHeight))
        sleepColor.setFill()
        linePath.fill()
        linePath.removeAllPoints()
        
        let startLabel = UILabel(frame: CGRect(x: 0, y: height - 16 , width: width/2, height: labelHeight))
        startLabel.text = startTime.substringToIndex(startTime.startIndex.advancedBy(5))
        startLabel.font = UIFont.systemFontOfSize(height * fontPer)
        startLabel.textAlignment = .Left
        self.addSubview(startLabel)
        
        let endLabel = UILabel(frame: CGRect(x: width/2, y: height - 16 , width: width/2, height: labelHeight))
        endLabel.text = endTime.substringToIndex(endTime.startIndex.advancedBy(5))
        endLabel.font = UIFont.systemFontOfSize(height * fontPer)
        endLabel.textAlignment = .Right
        self.addSubview(endLabel)
        
        let lineWidth = (width - 8) / CGFloat(sleepValues.count)
        
        for index in 0...sleepValues.count - 1 {
            if sleepValues[index] != 1 {
                linePath.moveToPoint(CGPoint(x: CGFloat(index) * lineWidth + margin, y: height - labelHeight))
                linePath.addLineToPoint(CGPoint(x: CGFloat(index) * lineWidth + margin, y: labelHeight * 2))
                
                switch sleepValues[index] {
                case 2:
                    restlessColor.setStroke()
                case 3:
                    awakeColor.setStroke()
                default:
                    sleepColor.setStroke()
                }
                linePath.lineWidth = lineWidth
                linePath.stroke()
                linePath.removeAllPoints()
            }
        }
        
    }
}
