//
//  GradientBG.swift
//  OnMyFeet
//
//  Created by apple on 16/3/27.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

@IBDesignable class GradientBG: UIView {

    fileprivate var _gradientLayer:CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x:0, y:1.0)
        gradient.endPoint = CGPoint.zero
        gradient.locations = [0.0,1.0]
        gradient.colors = [UIColor.blue.cgColor,UIColor.orange.cgColor]
        gradient.borderColor = UIColor.black.cgColor
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
    
    fileprivate func commonSetup() {
        self.layer.delegate = self
        self.layer.addSublayer(_gradientLayer)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        let w = self.bounds.width
        let h = self.bounds.height
        _gradientLayer.bounds = CGRect(x: 0, y: 0, width: w, height: h)
        _gradientLayer.position = CGPoint(x: w/2.0, y: h/2.0)
        
        let step:CGFloat = 1.0 / 3 / CGFloat(40)
        let locations:[CGFloat] = (0...40).map({ i in return (step * CGFloat(i))})
        let theLoc:[CGFloat] = (0...40).map({ i in return (step * 3 * CGFloat(i))})
        _gradientLayer.colors = locations.map({return UIColor(hue: $0, saturation: 0.7, brightness: 1.0, alpha: 1.0).cgColor})
        _gradientLayer.locations = theLoc as [NSNumber]?
    }
}
