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
    
    var distance: CGFloat = 0.0
    var length: CGFloat = 0.0
    var theFlag = true
    var _flag = false
    
    var pictures = [UIImage]()
    var questions = [String]()
    var examples = [String]()
    
    var finalPictures = [UIImage]()
    var finalQuestions = [String]()
    var finalExamples = [String]()
    var finalAnswers = [String]()
    
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
                finalAnswers[index] = ""
            }
            if (_flag == true) {
                finalAnswers[index] = textView.text!
            }
            index -= 1
            show()
            if (_flag == false) {
                finalAnswers[index] = ""
                
            }
            if (_flag == true) {
                finalAnswers[index] = textView.text!
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
        if (index < indexes.count) {
            if (_flag == false) {
                finalAnswers[index] = ""
            }
            if (_flag == true) {
                finalAnswers[index] = textView.text!
            }
            
            if (index == indexes.count - 1) {
                saveToCoreData()
                goNext()
            }
            
            if (index < indexes.count - 1) {
                index += 1
                show()
                if (index == indexes.count - 1 ) {
                    nextBtn.setTitle("Finished", forState: .Normal)
                }
            }
        }
    }
    
    func saveToCoreData() {
        if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
            let managedObjectContext = appDel.managedObjectContext
            
            for index in 0..<indexes.count {
                let thePicture = finalPictures[index]
                let theQuestion = finalQuestions[index]
                let theExample = finalExamples[index]
                let theAnswer = finalAnswers[index]
                
                GoalDataManager().insertGoalData(managedObjectContext, picture: thePicture, question: theQuestion, example: theExample, answer: theAnswer)
            }
            GoalDataManager().save(managedObjectContext)
        }
    }
    
    func initialization() {
        for index in 0...15 {
            pictures.append(UIImage (named: "\(index)")!)
        }
        questions = ["Who do you spend time with? What do you typically do together?", "What house or yard activities do you enjoy or are important to you?", "What kind of volunteer work do you like to do?", "What kinds of outdoor activities do you enjoy?", "What kind of physical activity or exercises do you enjoy?", "How does this fit in your life?", "What activities do you want to do with your pet?", "What places do you want to visit?", "What do you enjoy cooking or baking?", "Where do you like to go?", "Where do you like to go?", "How does this fit in your life?", "Where do you often go to?", "Do you enjoy movies or plays? How does this fit in your life?", "How does this fit in your life?", "Where do you shop? What is important about shopping?"]
        examples = ["For example, \"Going to the coffee shop with my friend Bill.\"", "For example, \"Pruning the bushes in front of my house.\"", "For example, \"Helping in the reading program at the library.\"", "For example, \"Going on walks in the park.\"", "For example, \"Going to the pool to swim laps.\"", "For example, \"Attending weekly service at my church.", "For example, \"Walking my dog.", "For example, \"Visiting my daughter in Vancouver.", "For example, \"Cooking for my daughter.\"", "For example, \"Going to a baseball game.\"", "For example, \"Going to the symphony.\"", "For example, \"Taking the bus to the casino.\"", "For example, \"Getting my hair done at the salon.\"", "For example, \"Going to the movie theatre with my husband.\"", "For example, \"Having brunch at my local diner.\"", "For example, \"Picking out fresh produce at the grocery store.\""]
        
        for index in 0..<indexes.count {
            finalPictures.append(pictures[indexes[index]])
            finalQuestions.append(questions[indexes[index]])
            finalExamples.append(examples[indexes[index]])
            finalAnswers.append("")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        
        if (index == 0) {
            show()
            if (indexes.count == 1) {
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
        
        //        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonalizeGoalsViewController.goBack))
        //        backBtn.tintColor = UIColor.whiteColor()
        //        navigationItem.leftBarButtonItem = backBtn
        
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
        imageView.image = finalPictures[index]
        question.text = finalQuestions[index]
        example.text = finalExamples[index]
        textView.text = finalAnswers[index]
        
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
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goHome(){
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func goNext(){
        let storyboardIdentifier = "ViewGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
}
