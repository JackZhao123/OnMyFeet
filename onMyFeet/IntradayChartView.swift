//
//  IntradayChartView.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-06.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

@IBDesignable class IntradayChartView: UIView {
    

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let width = rect.width
        let height = rect.height
        let topBorder:CGFloat = 10.0
        let bottomBorder:CGFloat = 40.0
        let leftMargin:CGFloat = 40.0
        
        let linePath = UIBezierPath()
        
        //Draw X axis
        linePath.moveToPoint(CGPoint(x: leftMargin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width, y: height - bottomBorder))
        UIColor.blackColor().setStroke()
        linePath.lineWidth = 1.5
        linePath.stroke()

        linePath.removeAllPoints()
        
        //Draw top line
        linePath.moveToPoint(CGPoint(x: leftMargin, y: 0+0.5))
        linePath.addLineToPoint(CGPoint(x: width, y: 0+0.5))
        
        //Draw middle line
        linePath.moveToPoint(CGPoint(x: leftMargin, y: (height - bottomBorder)/3 ))
        linePath.addLineToPoint(CGPoint(x: width, y: (height - bottomBorder)/3 ))
        
        //Draw Bottom Line
        linePath.moveToPoint(CGPoint(x: leftMargin, y: 2 * (height - bottomBorder)/3 ))
        linePath.addLineToPoint(CGPoint(x: width, y: 2 * (height - bottomBorder)/3 ))
        
        let color = UIColor.grayColor()
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()
        
        
    }

}
