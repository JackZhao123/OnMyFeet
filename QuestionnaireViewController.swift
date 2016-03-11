//
//  QuestionnaireViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var testEntryView: UITextView!
    var testEntry: String?
    var numOfValue:Int = 11
    var labelDic: [Int:String] = [Int:String]()
    var question:Questionnaire?

    var onlyTextEnable = false
    var questionSet: [String]!
    var scale: [String]!
    var mScrollView: UIScrollView!
    let questionSpace:CGFloat = 96.0
    var defaultValue: Float!
    
    var resultArray: [Float] = [Float]()
    var resultLabelArray: [UILabel] = [UILabel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let finishButton = UIBarButtonItem(title: "Submit", style: .Done, target: self, action: "submit")
        finishButton.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = finishButton
        
        mScrollView = UIScrollView(frame: CGRect(x: 0, y: 64.0, width: screenWidth, height: screenHeight - 64.0))
        
        testEntry = question?.testEntry
        numOfValue = (question?.numberOfValue)!
        labelDic = (question?.labelDic)!
        questionSet = question?.questionSet
        onlyTextEnable = (question?.onlyTextEnable)!
        
        self.view.addSubview(mScrollView)
        initAllLabel()
    }
    
    func initAllLabel() {
        
        testEntryView = UITextView(frame: CGRect(x: 8.0, y: 8.0, width: screenWidth, height: 100.0))
        testEntryView.backgroundColor = .None
        testEntryView.textColor = UIColor.whiteColor()

        testEntryView.textAlignment = .Left
        testEntryView.font = UIFont.systemFontOfSize(18.0)
        testEntryView.userInteractionEnabled = false
        
        if let testEntry = testEntry {
            testEntryView.text = testEntry
        } else {
            testEntryView.text = "Something Wrong..."
        }
        
        fitSizeWithContent(testEntryView)
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: testEntryView.frame.height + 8))
        backgroundView.backgroundColor = UIColor(red: (139/255.0), green: (195/255.0), blue: (74/255.0), alpha: 1.0)
        
        mScrollView.addSubview(backgroundView)
        mScrollView.addSubview(testEntryView)
        
        let startPoint = testEntryView.bounds.height + 16
        var margin:CGFloat = 0.0
        
        if let questionSet = questionSet {
            for index in 0...questionSet.count - 1 {
                resultArray.append(0)
                //QuestionTextView
                let questionTextView = UITextView(frame: CGRect(x: 8.0, y: startPoint + margin, width: screenWidth - 16.0, height: 32.0))
                questionTextView.textAlignment = .Left
                questionTextView.userInteractionEnabled = false
                questionTextView.font = UIFont.systemFontOfSize(18.0)
                questionTextView.text = questionSet[index]
                
                
                fitSizeWithContent(questionTextView)
                self.mScrollView.addSubview(questionTextView)
                margin = margin + questionSpace + questionTextView.frame.height
                
                //Slider
                let slider = UISlider(frame: CGRect(x: 8, y: margin - questionSpace/2.0 + startPoint - 15, width: screenWidth - 16.0, height: 32))
                slider.minimumValue = 0
                slider.maximumValue = Float(numOfValue - 1)
                slider.tag = index
                defaultValue = (slider.maximumValue) / 2
            
                slider.value = defaultValue
                slider.addTarget(self, action: "sliderValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                
                self.mScrollView.addSubview(slider)
                
                //ResultLabel
                let resultLabel = UILabel(frame:(CGRect(x:8.0, y: slider.frame.origin.y - 21, width: screenWidth - 16.0, height:21)))
                resultLabel.font = UIFont.systemFontOfSize(15.0)
                resultLabel.textColor = UIColor.blueColor()
                resultLabel.textAlignment = .Center
                resultLabel.text = ""
                resultLabel.tag = index
                self.mScrollView.addSubview(resultLabel)
                resultLabelArray.append(resultLabel)
                
                //LeftAndRightLabel
                let leftLabel = UILabel(frame:(CGRect(x:4.0, y: slider.frame.origin.y + 32, width:91, height:21)))
                leftLabel.textColor = UIColor.lightGrayColor()
                
                if let leftText = labelDic[0] {
                    leftLabel.text = leftText
                    fitSizeWithContent(leftLabel)
                } else {
                    leftLabel.text = "0"
                }
                
//                leftLabel.text = "cannot do it"
                self.mScrollView.addSubview(leftLabel)
                
                let rightLabel = UILabel(frame:(CGRect(x:screenWidth - 91 - 4, y: slider.frame.origin.y + 32, width:91, height:21)))
                rightLabel.textAlignment = .Right
                rightLabel.textColor = UIColor.lightGrayColor()
                
                if let rightText = labelDic[numOfValue - 1] {
                    rightLabel.text = rightText
                    fitSizeWithContent(rightLabel)
                } else {
                    rightLabel.text = "\(numOfValue - 1)"
                }
                
                self.mScrollView.addSubview(rightLabel)
            }
        }
        
        let newSize = CGSize(width: screenWidth, height: margin+startPoint)
        mScrollView.contentSize = newSize
    }
    
    func fitSizeWithContent(view:UIView) {
        let fixedWidth = view.frame.size.width
        let newSize = view.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = view.frame
        if(view.frame.origin.x + newSize.width >= screenWidth) {
            newFrame = CGRect(x: screenWidth - newSize.width - 4, y: view.frame.origin.y , width: newSize.width, height: newSize.height)
        }
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        view.frame = newFrame;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sliderValueChanged(sender:AnyObject) {
        let slider = sender as? UISlider
        
        
        if let slider = slider {
            let halfPoint: Int = Int(slider.value + 0.5)
            slider.setValue( Float(halfPoint), animated: false)
            resultArray[slider.tag] = slider.value
            
            if let string = labelDic[halfPoint] {
                if onlyTextEnable {
                    resultLabelArray[slider.tag].text = string
                } else {
                    resultLabelArray[slider.tag].text = "\(halfPoint), " + string
                }
                
            } else {
                resultLabelArray[slider.tag].text = "\(halfPoint)"

            }
        }
    }
    
    func submit() {
        
    }
}
