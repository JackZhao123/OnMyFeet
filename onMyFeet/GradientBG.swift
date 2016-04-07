//
//  GradientBG.swift
//  OnMyFeet
//
//  Created by apple on 16/3/27.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

@IBDesignable class GradientBG: UIView {

    private var _gradientLayer:CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x:0, y:1.0)
        gradient.endPoint = CGPoint.zero
        gradient.locations = [0.0,1.0]
        gradient.colors = [UIColor.blueColor().CGColor,UIColor.orangeColor().CGColor]
        gradient.borderColor = UIColor.blackColor().CGColor
        return gradient
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    private func commonSetup() {
        self.layer.delegate = self
        self.layer.addSublayer(_gradientLayer)
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        if layer != self.layer {return}
        
        let w = self.bounds.width
        let h = self.bounds.height
        _gradientLayer.bounds = CGRectMake(0, 0, w, h)
        _gradientLayer.position = CGPointMake(w/2.0, h/2.0)
        
        let step:CGFloat = 1.0 / 3 / CGFloat(40)
        let locations:[CGFloat] = (0...40).map({ i in return (step * CGFloat(i))})
        let theLoc:[CGFloat] = (0...40).map({ i in return (step * 3 * CGFloat(i))})
        _gradientLayer.colors = locations.map({return UIColor(hue: $0, saturation: 0.7, brightness: 1.0, alpha: 1.0).CGColor})
        _gradientLayer.locations = theLoc
    }

}
