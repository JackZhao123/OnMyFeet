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
    
    override func draw(_ rect: CGRect) {
        
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
        
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        if graphPoints.count >= 1 {
            
            let graphPath = UIBezierPath()
            
            graphPath.move(to: CGPoint(x:xPoint(0), y:yPoint(graphPoints[0])))
            
            for i in 1..<graphPoints.count {
                let nextPoint = CGPoint(x: xPoint(i), y: yPoint(graphPoints[i]))
                graphPath.addLine(to: nextPoint)
            }
            graphPath.stroke()
            
            
            context?.saveGState()
            let clippingPath = graphPath.copy() as! UIBezierPath
            
            clippingPath.addLine(to: CGPoint (x: xPoint(graphPoints.count - 1), y: h))
            clippingPath.addLine(to: CGPoint(x: xPoint(0), y: h))
            clippingPath.close()
            
            clippingPath.addClip()
            
            UIColor(white: 1.0, alpha: 0.15).setFill()
            let rectPath = UIBezierPath(rect: self.bounds)
            rectPath.fill()
            context?.restoreGState()
            
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            
            
            
            for i in 0..<graphPoints.count {
                var point = CGPoint(x: xPoint(i), y: yPoint(graphPoints[i]))
                point.x -= 4.0/2
                point.y -= 4.0/2
                
                let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: 4, height: 4)))
                circle.fill()
                
                let line = UIBezierPath()
                line.move(to: CGPoint(x: xPoint(i), y: h-2))
                line.addLine(to: CGPoint(x: xPoint(i), y: yPoint(graphPoints[i])))
                
                let color = UIColor(white: 1.0, alpha: 0.7)
                color.setStroke()
                
                line.lineWidth = 2.0
                line.stroke()
            }
            
            
            
            let linePath = UIBezierPath()
            
            linePath.move(to: CGPoint(x: margin/2, y: 2))
            linePath.addLine(to: CGPoint(x: w - margin/2, y: 2))
            
            linePath.move(to: CGPoint(x: margin/2, y: h - 2))
            linePath.addLine(to: CGPoint(x: w - margin/2, y: h - 2))
            
            let color = UIColor(white: 1.0, alpha: 0.7)
            color.setStroke()
            
            linePath.lineWidth = 2.0
            linePath.stroke()
                    
        }
    }
}
