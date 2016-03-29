//
//  DashView.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-26.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

protocol DashViewDelegate {
    func dateValueDidChangeFrom(dateTime:String, by interval:Int)
}

class DashView: UIView {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    let dateLabel: UILabel! = UILabel()
    let numLabel:UILabel! = UILabel()
    let nameLabel:UILabel! = UILabel()
    let rightBtn: UIButton! = UIButton(type: .System)
    let leftBtn: UIButton! = UIButton(type: .System)
    
    let activeLabel:UILabel! = UILabel()
    let sedentaryLabel:UILabel! = UILabel()
    let lightlyLabel:UILabel! = UILabel()
    let activeName:UILabel! = UILabel()
    let lightlyName:UILabel! = UILabel()
    let sedentaryName:UILabel! = UILabel()
    
    //Color
    let activeColor = UIColor(red: 0.000, green: 0.741, blue: 0.231, alpha: 1.00)
    let yColor = UIColor(red: 0.925, green: 0.839, blue: 0.247, alpha: 1.00)
    
    var delegate: DashViewDelegate?
    var dataItem: DataItem {
        didSet{
            setLabelText()
        }
    }
    //MARK: Init
    override init(frame: CGRect) {
        self.dataItem = DataItem(title: "Steps", date: "1970-01-01")
        super.init(frame: frame)
        makeSubview()
    }
    
    convenience init(item:DataItem){
        
        self.init(frame: CGRect.zero)
        self.dataItem = item
        makeSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeSubview() {

        self.backgroundColor = UIColor(red: 66/255.0, green: 67/255.0, blue: 70/255.0, alpha: 1.00)
        //DateLabel
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFontOfSize(22.0)
        dateLabel.textAlignment = .Center
        dateLabel.textColor = yColor
        self.addSubview(dateLabel)
        
        //NumLabel
        numLabel.font = UIFont.systemFontOfSize(60.0)
        configureLabel(numLabel)
        
        //NameLabel
        nameLabel.font = UIFont.systemFontOfSize(37.0)
        configureLabel(nameLabel)
        
        setLabelText()
        
        //Button
        let leftMargin = screenWidth/2 - 100
        let rightMargin = screenWidth/2 + 100  - 28
        leftBtn.tintColor = yColor
        rightBtn.tintColor = yColor
        
        leftBtn.setImage(UIImage(named: "left-arrow"), forState: .Normal)
        leftBtn.frame = CGRect(x: leftMargin, y: 8, width: 28, height: 28)
        leftBtn.addTarget(self, action: #selector(DashView.decreaseDay), forControlEvents: .TouchUpInside)
        
        rightBtn.setImage(UIImage(named: "right-arrow" ), forState: .Normal)
        rightBtn.frame = CGRect(x: rightMargin, y: 8, width: 28, height: 28)
        rightBtn.addTarget(self, action: #selector(DashView.addDay), forControlEvents: .TouchUpInside)
        
        self.addSubview(leftBtn)
        self.addSubview(rightBtn)
        
        //ViewsDictionary
        let viewsDictionary = ["date":dateLabel, "view":self, "data":numLabel, "name":nameLabel,"leftBtn":leftBtn]
        
        //Constraints
        let date_centerX_constraint = NSLayoutConstraint(item: dateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let date_control_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[date(28)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let date_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:[date(200)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let data_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[data]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let name_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[name]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        let bottom_control_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[data(60)]-[name(44)]-30-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        
        self.addConstraints(data_control_constraint_H)
        self.addConstraints(name_control_constraint_H)
        self.addConstraints(bottom_control_constraint_V)
        self.addConstraint(date_centerX_constraint)
        
        dateLabel.addConstraints(date_constraint_H)
        self.addConstraints(date_control_constraint_V)
        
        //Intensity Label
        configureLabel(sedentaryLabel)
        configureLabel(activeLabel)
        configureLabel(lightlyLabel)
        sedentaryLabel.font = UIFont.systemFontOfSize(40.0)
        activeLabel.font = UIFont.systemFontOfSize(40.0)
        lightlyLabel.font = UIFont.systemFontOfSize(40.0)
        
        activeLabel.textColor = activeColor
        lightlyLabel.textColor = yColor
        
        let secDictionary = ["active":activeLabel, "sedentary":sedentaryLabel, "lightly":lightlyLabel]
        sedentaryLabel.text = "9999"
        activeLabel.text = "9999"
        lightlyLabel.text = "9999"

        //Intensity Constraints
        let intensity_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[active]-[lightly(==active)]-[sedentary(==active)]-|", options: .AlignAllCenterY, metrics: nil, views: secDictionary)
        let lightly_control_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[lightly(60)]-74-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: secDictionary)
        let active_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[active(60)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: secDictionary)
        let sedentary_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[sedentary(60)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: secDictionary)
        
        self.addConstraints(intensity_control_constraint_H)
        self.addConstraints(lightly_control_constraint_V)
        
        sedentaryLabel.addConstraints(sedentary_constraint_V)
        activeLabel.addConstraints(active_constraint_V)
        
        //Intensity Name Label
        configureLabel(sedentaryName)
        configureLabel(activeName)
        configureLabel(lightlyName)
        
        sedentaryName.text = "Sedentary"
        activeName.text = "Active"
        lightlyName.text = "Lightly"
        
        activeName.textColor = activeColor
        lightlyName.textColor = yColor
        
        sedentaryName.font = UIFont.systemFontOfSize(20.0)
        activeName.font = UIFont.systemFontOfSize(20.0)
        lightlyName.font = UIFont.systemFontOfSize(20.0)
        
        let thirDictionary = ["sName": sedentaryName, "aName":activeName, "lName":lightlyName]
        
        //Intensity Name Constraint
        let intensity_name_control_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[aName]-[lName(==aName)]-[sName(==aName)]-|", options: .AlignAllCenterY, metrics: nil, views: thirDictionary)
        let lightlyName_control_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[lName(44)]-40-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: thirDictionary)
        let activeName_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[aName(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: thirDictionary)
        let sedentaryName_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:[sName(44)]", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: thirDictionary)
        
        self.addConstraints(intensity_name_control_H)
        self.addConstraints(lightlyName_control_constraint_V)
        
        sedentaryName.addConstraints(sedentaryName_constraint_V)
        activeName.addConstraints(activeName_constraint_V)

        configureIntensityView()
    }
    
    func configureLabel(label:UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        self.addSubview(label)
    }
    
    func setLabelText(){
        dateLabel.text = DateStruct.dayMonthFormatFromDefault(dataItem.date)
        nameLabel.text = dataItem.title
        configureIntensityView()
        
        switch dataItem.title {
            case "Steps":
                numLabel.text = String(format: "%.0f", arguments: [dataItem.number])
            case "Distance":
                let number = dataItem.number * 1000
                numLabel.text = String(format: "%.2f m", arguments: [number])
            case "Sleep Hours":
                let hours = dataItem.number / 60.0
                numLabel.text = String(format: "%.0f", arguments: [hours])
            case "Intensity":
                activeLabel.text = String(format: "%.0f", arguments: [dataItem.activeNum])
                sedentaryLabel.text = String(format: "%.0f", arguments: [dataItem.sedentaryNum])
                lightlyLabel.text = String(format: "%.0f", arguments: [dataItem.lightlyNum])
            default:
                break
        }
    }
    
    func configureIntensityView() {
        if self.dataItem.title == "Intensity" {
            self.numLabel.hidden = true
            self.nameLabel.hidden = true
            
            self.activeLabel.hidden = false
            self.activeName.hidden = false
            self.lightlyLabel.hidden = false
            self.lightlyName.hidden = false
            self.sedentaryName.hidden = false
            self.sedentaryLabel.hidden = false
        } else {
            self.numLabel.hidden = false
            self.nameLabel.hidden = false
            
            self.activeLabel.hidden = true
            self.activeName.hidden = true
            self.lightlyLabel.hidden = true
            self.lightlyName.hidden = true
            self.sedentaryName.hidden = true
            self.sedentaryLabel.hidden = true
        }
    }
    
    func addDay(){
        delegate?.dateValueDidChangeFrom(self.dataItem.date, by: 1)
    }
    
    func decreaseDay(){
        delegate?.dateValueDidChangeFrom(self.dataItem.date, by: -1)
    }

}
