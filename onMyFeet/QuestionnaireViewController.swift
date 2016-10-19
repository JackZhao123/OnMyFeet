//
//  QuestionnaireViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class QuestionnaireViewController: UIViewController {
    
    //Outlet 
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
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
    
    var answerFlag:[Bool] = [Bool]()
    var questionTitle: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = false
        
        let finishButton = UIBarButtonItem(title: "Submit", style: .done, target: self, action: #selector(QuestionnaireViewController.submit))
        finishButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = finishButton
        
        mScrollView = UIScrollView(frame: CGRect(x: 0, y: 64.0, width: screenWidth, height: screenHeight - 64.0))
        
        testEntry = question?.testEntry
        numOfValue = (question?.numberOfValue)!
        labelDic = (question?.labelDic)!
        questionSet = question?.questionSet
        onlyTextEnable = (question?.onlyTextEnable)!
        
        self.view.addSubview(mScrollView)
        
        initAllLabel()
        
        self.view.bringSubview(toFront: indicatorView)
        indicatorView.layer.cornerRadius = 8.0
        indicatorView.clipsToBounds = true
        indicatorView.isHidden = true
    }
    
    func initAllLabel() {
        
        testEntryView = UITextView(frame: CGRect(x: 8.0, y: 72.0, width: screenWidth, height: 100.0))
        testEntryView.backgroundColor = .none
        testEntryView.textColor = UIColor.white

        testEntryView.textAlignment = .left
        testEntryView.font = UIFont.systemFont(ofSize: 18.0)
        testEntryView.isUserInteractionEnabled = false
        
        if let testEntry = testEntry {
            testEntryView.text = testEntry
        } else {
            testEntryView.text = "Something Wrong..."
        }
        
        fitSizeWithContent(testEntryView)
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: testEntryView.frame.height + 8))
        backgroundView.backgroundColor = UIColor(red: (139/255.0), green: (195/255.0), blue: (74/255.0), alpha: 1.0)
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(testEntryView)
        
        let startPoint = testEntryView.bounds.height + 16
        var margin:CGFloat = 0.0
        
        if let questionSet = questionSet {
            for index in 0...questionSet.count - 1 {
                answerFlag.append(false)
                resultArray.append(0)
                //QuestionTextView
                let questionTextView = UITextView(frame: CGRect(x: 8.0, y: startPoint + margin, width: screenWidth - 16.0, height: 32.0))
                questionTextView.textAlignment = .left
                questionTextView.isUserInteractionEnabled = false
                questionTextView.font = UIFont.systemFont(ofSize: 18.0)
                let mark = NSMutableAttributedString(string: "\(index+1)/\(questionSet.count), ", attributes: [NSForegroundColorAttributeName:UIColor.gray, NSFontAttributeName:UIFont.systemFont(ofSize: 18.0)])
                
                mark.append( NSAttributedString(string: questionSet[index], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18.0)]) )
                
                questionTextView.attributedText =  mark
                
                
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
                slider.addTarget(self, action: #selector(QuestionnaireViewController.sliderValueChanged(_:)), for: UIControlEvents.valueChanged)
                
                self.mScrollView.addSubview(slider)
                
                //ResultLabel
                let resultLabel = UILabel(frame:(CGRect(x:8.0, y: slider.frame.origin.y - 21, width: screenWidth - 16.0, height:21)))
                resultLabel.font = UIFont.systemFont(ofSize: 15.0)
                resultLabel.textColor = UIColor.blue
                resultLabel.textAlignment = .center
                resultLabel.text = ""
                resultLabel.tag = index
                self.mScrollView.addSubview(resultLabel)
                resultLabelArray.append(resultLabel)
                
                //LeftAndRightLabel
                let leftLabel = UILabel(frame:(CGRect(x:4.0, y: slider.frame.origin.y + 32, width:91, height:21)))
                leftLabel.textColor = UIColor.lightGray
                
                if let leftText = labelDic[0] {
                    leftLabel.text = leftText
                    fitSizeWithContent(leftLabel)
                } else {
                    leftLabel.text = "0"
                }
                
                self.mScrollView.addSubview(leftLabel)
                
                let rightLabel = UILabel(frame:(CGRect(x:screenWidth - 91 - 4, y: slider.frame.origin.y + 32, width:91, height:21)))
                rightLabel.textAlignment = .right
                rightLabel.textColor = UIColor.lightGray
                
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
    
    func fitSizeWithContent(_ view:UIView) {
        let fixedWidth = view.frame.size.width
        let newSize = view.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
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
    
    func sliderValueChanged(_ sender:AnyObject) {
        let slider = sender as? UISlider
        
        
        if let slider = slider {
            let halfPoint: Int = Int(slider.value + 0.5)
            slider.setValue( Float(halfPoint), animated: false)
            resultArray[slider.tag] = slider.value
            answerFlag[slider.tag] = true
            
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
        var notAnswerList = [Int]()
        for index in 0...answerFlag.count - 1 {
            if answerFlag[index] == false {
                notAnswerList.append(index + 1)
            }
        }
        
        
        if notAnswerList.count > 0 {
            let title = "Please answer all the questions before submit."
            var message = "Please answer question\nNo "
            for i in notAnswerList {
                message = message + "\(i). "
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: {(action) -> Void in
                alert.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        } else {
            indicatorView.isHidden = false
            indicator.startAnimating()
            
            var data = [String:AnyObject]()
            var answerData = [String:AnyObject]()
            
            data["title"] = questionTitle as AnyObject?
            data["group"] = 0 as AnyObject?
            
            for i in 0..<questionSet.count {
                let answerValue = Int(resultArray[i])
                let answerPercent = (resultArray[i] / Float(numOfValue - 1) ) * 100
                let answerLabel = labelDic[answerValue]
                var label: String! = String(answerValue)
                
                if let answerLabel = answerLabel {
                    label = answerLabel
                }
                
                let answerArray: [AnyObject] = [answerValue as AnyObject, answerPercent as AnyObject, label as AnyObject, labelDic[0]! as AnyObject, labelDic[numOfValue - 1]! as AnyObject]
                answerData[questionSet[i]] = answerArray as AnyObject?
            }
            
            data["feedback"] = answerData as AnyObject?
            data["fb_id"] = "\(Constants.Fitbit.id)" as AnyObject?
            
        }
    }
}
