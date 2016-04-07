//
//  LineChart.swift
//  OnMyFeet
//
//  Created by apple on 16/3/26.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

@IBDesignable class LineChart: UIView {

    var thePoints: [Int] {
        get {
            return graphPoints
        }
        set {
            graphPoints = newValue
        }
    }
    
    var graphPoints: [Int] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        let w = rect.width
        let h = rect.height
        
        
        let margin: CGFloat = 20.0
        let xPoint = { (column: Int) -> CGFloat in
            let space = (w - margin*2)/CGFloat(6)
            var x: CGFloat = CGFloat(column) * space
            x += margin
            return x
        }
        

        let yPoint = { (graphPoint: Int) -> CGFloat in
            let space = (h - 2*2)/1000
            var y:CGFloat = CGFloat(graphPoint) * space
            y += 2
            return (h - y)
        }
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        if graphPoints.count >= 1 {
            
            let graphPath = UIBezierPath()
            
            graphPath.moveToPoint(CGPoint(x:xPoint(0), y:yPoint(graphPoints[0])))
            
            for i in 1..<graphPoints.count {
                let nextPoint = CGPoint(x: xPoint(i), y: yPoint(graphPoints[i]))
                graphPath.addLineToPoint(nextPoint)
            }
            graphPath.stroke()
            
            
            CGContextSaveGState(context)
            let clippingPath = graphPath.copy() as! UIBezierPath
            
            clippingPath.addLineToPoint(CGPoint (x: xPoint(graphPoints.count - 1), y: h))
            clippingPath.addLineToPoint(CGPoint(x: xPoint(0), y: h))
            clippingPath.closePath()
            
            clippingPath.addClip()
            
            UIColor(white: 1.0, alpha: 0.15).setFill()
            let rectPath = UIBezierPath(rect: self.bounds)
            rectPath.fill()
            CGContextRestoreGState(context)
            
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            
            
            
            for i in 0..<graphPoints.count {
                var point = CGPoint(x: xPoint(i), y: yPoint(graphPoints[i]))
                point.x -= 4.0/2
                point.y -= 4.0/2
                
                let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 4, height: 4)))
                circle.fill()
                
                let line = UIBezierPath()
                line.moveToPoint(CGPoint(x: xPoint(i), y: h-2))
                line.addLineToPoint(CGPoint(x: xPoint(i), y: yPoint(graphPoints[i])))
                
                let color = UIColor(white: 1.0, alpha: 0.7)
                color.setStroke()
                
                line.lineWidth = 2.0
                line.stroke()
            }
            
            
            
            let linePath = UIBezierPath()
            
            linePath.moveToPoint(CGPoint(x: margin/2, y: 2))
            linePath.addLineToPoint(CGPoint(x: w - margin/2, y: 2))
            
            linePath.moveToPoint(CGPoint(x: margin/2, y: h - 2))
            linePath.addLineToPoint(CGPoint(x: w - margin/2, y: h - 2))
            
            let color = UIColor(white: 1.0, alpha: 0.7)
            color.setStroke()
            
            linePath.lineWidth = 2.0
            linePath.stroke()
                    
        }
    }
}
