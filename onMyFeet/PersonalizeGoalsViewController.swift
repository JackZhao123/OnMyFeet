//
//  PersonalizeGoalsViewController.swift
//  OnMyFeet
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

class PersonalizeGoalsViewController: UIViewController, UITextViewDelegate {
    
    var index = 0
    var indexes = [Int]()
    var goals = [Goal]()
    var distance: CGFloat = 0.0
    var length: CGFloat = 0.0
    var theFlag = true
    var _flag = false
    var flagExamples = [String]()
    
    @IBOutlet weak var bottomConstrain: NSLayoutConstraint!
    @IBOutlet weak var topConstrain: NSLayoutConstraint!
    @IBOutlet weak var widthConstrain: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var example: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func previousBtn(sender: UIButton) {
        nextBtn.setTitle("Next", forState: .Normal)
        if (index > 0) {
            if (_flag == false) {
                GoalDataManager().updateGoalAnswer(goals[index], answer: "")
            }
            if (_flag == true) {
                GoalDataManager().updateGoalAnswer(goals[index], answer: textView.text!)
            }
            index -= 1
            show()
            if (_flag == false) {
                GoalDataManager().updateGoalAnswer(goals[index], answer: "")
            }
            if (_flag == true) {
                GoalDataManager().updateGoalAnswer(goals[index], answer: textView.text!)
            }
            if (index == 0) {
                previousBtn.enabled = false
                previousBtn.alpha = 0.5
            }
        }
    }
    
    @IBAction func nextBtn(sender: UIButton) {
        previousBtn.enabled = true
        previousBtn.alpha = 1.0
        if (index < goals.count) {
            if (_flag == false) {
                GoalDataManager().updateGoalAnswer(goals[index], answer: "")
            }
            if (_flag == true) {
                GoalDataManager().updateGoalAnswer(goals[index], answer: textView.text!)
            }
            
            if (index == goals.count - 1) {
                goNext()
            }
            
            if (index < goals.count - 1) {
                index += 1
                show()
                if (index == goals.count - 1 ) {
                    nextBtn.setTitle("Finished", forState: .Normal)
                }
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        for index in 0..<flagExamples.count {
            let theExample = flagExamples[index]
            let theGoal = GoalDataManager().predicateFetchGoal(theExample)
            goals.append(theGoal)
        }
        
        if (index == 0) {
            show()
            if (goals.count == 1) {
                nextBtn.setTitle("Finished", forState: .Normal)
            }
        }

        textView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PersonalizeGoalsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PersonalizeGoalsViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        if (index <= 0) {
            previousBtn.enabled = false
            previousBtn.alpha = 0.5
        }
        
        previousBtn.layer.cornerRadius = 5.0;
        previousBtn.layer.borderColor = UIColor.grayColor().CGColor
        previousBtn.layer.borderWidth = 1.5
        
        nextBtn.layer.cornerRadius = 5.0;
        nextBtn.layer.borderColor = UIColor.grayColor().CGColor
        nextBtn.layer.borderWidth = 1.5
        
        self.title = "Personalizing Goals"
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonalizeGoalsViewController.goBack))
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonalizeGoalsViewController.goHome))
        homeBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = homeBtn
        
        if (self.view.frame.height > self.view.frame.width) {
            topConstrain.constant = self.view.frame.height/10 - 50
            bottomConstrain.constant = topConstrain.constant
            widthConstrain.constant = self.view.frame.width/3*2
        }
        else if (self.view.frame.height < self.view.frame.width) {
            widthConstrain.constant = self.view.frame.width/15*7
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func show() {
        imageView.image = UIImage (data: goals[index].picture)
        question.text = goals[index].question
        example.text = goals[index].example
        textView.text = goals[index].answer
        
        if textView.text.isEmpty {
            textView.text = "Please enter your personalized goal here"
            textView.textColor = UIColor.lightGrayColor()
            _flag = false
        }
        else {
            textView.textColor = UIColor.blackColor()
            _flag = true
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        if (theFlag == true) {
            length = self.textView.contentSize.height
            distance = keyboardFrame.size.height - self.textView.frame.height - nextBtn.frame.height + length
        }
        
        scrollView.scrollEnabled = true
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: distance), animated: true)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        
        scrollView.scrollEnabled = false
    }
    
    func textViewDidChange(textView: UITextView) {
        if (self.textView.contentSize.height < textView.frame.height) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: distance + self.textView.contentSize.height - length), animated: true)
            distance += self.textView.contentSize.height - length
            length = self.textView.contentSize.height
            theFlag = false
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        _flag = true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter your personalized goal here"
            textView.textColor = UIColor.lightGrayColor()
            _flag = false
        }
    }
    
    func goBack(){
        let storyboardIdentifier = "ChooseGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! ChooseGoalsViewController
        desController.indexes = self.indexes
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
    func goHome(){
//        let storyboardIdentifier = "Menu"
//        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
//        self.navigationController!.pushViewController(desController, animated: true)
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    func goNext(){
        let storyboardIdentifier = "ViewGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
}
