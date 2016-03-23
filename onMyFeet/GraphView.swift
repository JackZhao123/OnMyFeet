//
//  GraphView.swift
//  Flo
//
//  Created by Zhao Xiongbin on 2016-03-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

protocol graphViewDelegate {
    func handleTap(sender:GraphView)
}

@IBDesignable class GraphView: UIView {
    @IBInspectable var startColor: UIColor = UIColor(red: 118/255.0, green: 184/255.0, blue: 82/255.0, alpha: 1.0)
    @IBInspectable var endColor: UIColor = UIColor(red: 141/255.0, green: 194/255.0, blue: 111/255.0, alpha: 1.0)
    
    var graphPoints: [Int] = [4,2,6,4,5,10,3] {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var dateArray:[String] = ["2016-01-99","2016-01-29","2016-01-99","2016-01-99","2016-01-99","2016-01-99","2016-01-99"] {
        didSet{
            setNeedsDisplay()
        }
    }
    var label:UILabel!
    var dateLabelArray = [UILabel]()
    var currentDate: String?
    var delegate:graphViewDelegate?
    var maxLabel:UILabel?
    var noDataLabel:UILabel?

    //MARK:Methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        label = UILabel(frame: CGRect(x: 20.0, y: 8, width: 159, height: 21))
        label.textColor = UIColor.whiteColor()
        label.text = "Default"
        self.addSubview(label)
        
        let margin:CGFloat = 20.0
        let topBorder:CGFloat = 60.0
        let columnXPoint = { (column:Int) -> CGFloat in
            let spacer = (frame.width - margin*2) / CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin - 7
            return x
        }
        
       //MARK: Init Label
        let weekdayArray = ["S","M","T","W","T","F","S"]
        for i in 0..<graphPoints.count {
            let dateLabel = UILabel(frame: CGRect(x: columnXPoint(i) - 1.5, y: frame.height - 40 + 18, width: 21, height: 21))
            dateLabel.font = UIFont.systemFontOfSize(14.0)
            dateLabel.textColor = UIColor.whiteColor()

            dateLabelArray.append(dateLabel)
            
            let dataLabel = UILabel(frame: CGRect(x: columnXPoint(i), y: frame.height - 40, width: 17, height: 21))
            
            dataLabel.textColor = UIColor.whiteColor()
            dataLabel.text = weekdayArray[i]
            self.addSubview(dataLabel)
            self.addSubview(dateLabel)
        }
        
        maxLabel = UILabel(frame: CGRect(x: frame.width - 68, y: topBorder - 20, width: 63.0, height: 21.0))
        maxLabel?.font = UIFont.systemFontOfSize(14.0)
        maxLabel?.textAlignment = NSTextAlignment.Right
        maxLabel?.textColor = UIColor.whiteColor()
        self.addSubview(maxLabel!)
        
        noDataLabel = UILabel(frame: CGRect(x: frame.width/2 - 62.5, y: frame.height/2 - 24.5, width: 125.0, height: 49.0))
        noDataLabel?.textAlignment = NSTextAlignment.Center
        noDataLabel?.font = UIFont.systemFontOfSize(27.0)
        noDataLabel?.textColor = UIColor.whiteColor()
        noDataLabel?.text = "No Data"
        
        let tapRecognizor = UITapGestureRecognizer(target: self, action: #selector(GraphView.handleTap))
        self.addGestureRecognizer(tapRecognizor)
        
    }
    
    func handleTap() {
        if let delegate = delegate {
            delegate.handleTap(self)
        }
    }
    
    override func drawRect(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        var notZero:Bool = false
        
        maxLabel?.text = String(graphPoints.maxElement()!)
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width: 8.0, height: 8.0))
        path.addClip()
        
        // Drawing code
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
        
        //Draw Curve , x axis point
        let margin:CGFloat = 20.0
        let columnXPoint = { (column:Int) -> CGFloat in
            let spacer = (width - margin*2 - 4) / CGFloat((self.graphPoints.count - 1))
            var x:CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }
        
        // y axis point 
        let topBorder:CGFloat = 60
        let bottomBorder:CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = graphPoints.maxElement()
        
        let columnYPoint = {(graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue!) * graphHeight
            y = graphHeight + topBorder - y
            return y
        }
        
        for i in 0..<graphPoints.count {
            let dateLabel = dateLabelArray[i]
            dateLabel.text = (dateArray[i] as NSString).substringFromIndex(8)
            
            if graphPoints[i] != 0 {
                notZero = true
            }

            if let currentDate = currentDate {
                if dateArray[i] == currentDate {
                    dateLabel.textColor = UIColor.redColor()
                } else {
                    dateLabel.textColor = UIColor.whiteColor()
                }
            }
        }
        
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        if(notZero){
            if maxLabel?.superview == nil {
                self.addSubview(maxLabel!)
                noDataLabel?.removeFromSuperview()
            }
            
            let graphPath = UIBezierPath()
            graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
            
            for i in 1..<graphPoints.count {
                let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
                graphPath.addLineToPoint(nextPoint)
                
            }
            
            CGContextSaveGState(context)
            
            let clippingPath = graphPath.copy() as! UIBezierPath
            clippingPath.addLineToPoint(CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
            clippingPath.addLineToPoint(CGPoint(x: columnXPoint(0), y: height))
            clippingPath.closePath()
            
            clippingPath.addClip()
            
            let highestYPoint = columnYPoint(maxValue!)
            startPoint = CGPoint(x: margin, y: highestYPoint)
            endPoint = CGPoint(x: margin, y: self.bounds.height)
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, [])
            CGContextRestoreGState(context)
            
            graphPath.lineWidth = 2.0
            graphPath.stroke()
            
            for i in 0..<graphPoints.count {
                var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
                point.x -= 5.0/2
                point.y -= 5.0/2
                
                let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
                circle.fill()
            }
        } else {
            self.maxLabel?.removeFromSuperview()
            self.addSubview(noDataLabel!)
        }
        
        
        let linePath = UIBezierPath()
        
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder))
        
        linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()

        linePath.lineWidth = 1.0
        linePath.stroke()

    }

}
