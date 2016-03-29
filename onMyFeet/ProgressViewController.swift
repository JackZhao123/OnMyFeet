//
//  ProgressViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-24.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit


class ProgressViewController: UIViewController, UIToolbarDelegate, DashViewDelegate {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var displayDate = DateStruct.getCurrentDate()
    
    //Subview
    var mSegment: UISegmentedControl!
    var mToolBar: UIToolbar!
    var briefView: DashView!
    var chartView: WeekView!
    
    //MARK: Init View
    override func viewDidLoad() {
        super.viewDidLoad()
        makeLayout()
        
    }
    
    func makeLayout(){
        //Segment Control
        mSegment = UISegmentedControl(items: ["Steps","Distance", "Sleep", "Intensity"])
        mSegment.frame = CGRect(x: 0.0, y: 4.0, width: screenWidth - 16, height: 32.0 )
        mSegment.tintColor = UIColor.whiteColor()
        mSegment.addTarget(self, action: #selector(ProgressViewController.segmentChanged), forControlEvents: UIControlEvents.ValueChanged)
        mSegment.selectedSegmentIndex = 0
        
        //ToolBar
        mToolBar = UIToolbar()
        mToolBar.barTintColor = UIColor(red: 0.122, green: 0.129, blue: 0.141, alpha: 1.00)
        let item = UIBarButtonItem(customView: mSegment)
        
        let negativeSeparator = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        negativeSeparator.width = -8
        mToolBar.items = [negativeSeparator,item,negativeSeparator]
        mToolBar.delegate = self
        mToolBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mToolBar)
        
        //Overall view
        let dataItem = DataItem(title: "Steps", date: displayDate)
        briefView = DashView(item: dataItem)
        briefView.translatesAutoresizingMaskIntoConstraints = false
        briefView.delegate = self
        self.view.addSubview(briefView)
        
        //Chart View
        chartView = WeekView(item: dataItem)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chartView)
        
        //Constraint
        let viewsDictionary = ["mSegment":mSegment, "mToolBar":mToolBar, "topGuide":self.topLayoutGuide, "briefView":briefView,"chartView":chartView]
        
        //ToolBarConstraint
        let toolbar_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[mToolBar(>=100)]-0-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsDictionary as! [String : AnyObject])
        let control_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-0-[mToolBar(50.0)]-0-[briefView(210)]-0-[chartView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary as! [String : AnyObject])
        let brief_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[briefView(>=100)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary as! [String : AnyObject])
        let chart_control_constraint_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[chartView(>=100)]-0-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary as! [String : AnyObject])

        self.view.addConstraints(toolbar_control_constraint_H)
        self.view.addConstraints(control_constraint_V)
        self.view.addConstraints(brief_control_constraint_H)
        self.view.addConstraints(chart_control_constraint_H)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        mSegment.bounds.size = CGSize(width: size.width - 16, height: 29.0)
    }
    
    //MARK: Load Different View
    func segmentChanged() {
        switch mSegment.selectedSegmentIndex {
        case 0:
            briefView.dataItem.title = "Steps"
        case 1:
            briefView.dataItem.title = "Distance"
        case 2:
            briefView.dataItem.title = "Sleep Hours"
        case 3:
            briefView.dataItem.title = "Intensity"
        default:
            break
        }
        briefView.dataItem.date = displayDate
        briefView.setLabelText()
        
        chartView.dataItem?.getWeeklyData()
        chartView.reloadChart()
    }
    
    //MARK: DashView delegate
    func dateValueDidChangeFrom(dateTime: String, by interval: Int) {
        let newDateTime = DateStruct.dateValueChangeFrom(dateTime, by: interval)
        briefView.dataItem.date = newDateTime
        displayDate = newDateTime
        briefView.setLabelText()
    }

}
