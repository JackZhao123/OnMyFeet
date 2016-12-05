//
//  PersonalizeGoalsViewController.swift
//  OnMyFeet
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import MagicalRecord

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
    
    @IBAction func previousBtn(_ sender: UIButton) {
        nextBtn.setTitle("Next", for: UIControlState())
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
                previousBtn.isEnabled = false
                previousBtn.alpha = 0.5
            }
        }
    }
    
    @IBAction func nextBtn(_ sender: UIButton) {
        previousBtn.isEnabled = true
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
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
            
            if (index < indexes.count - 1) {
                index += 1
                show()
                if (index == indexes.count - 1 ) {
                    nextBtn.setTitle("Finish", for: UIControlState())
                }
            }
        }
    }
    
    func saveToCoreData() {
        
        for index in 0..<indexes.count {
            let thePicture = finalPictures[index]
            let theQuestion = finalQuestions[index]
            let theExample = finalExamples[index]
            let theAnswer = finalAnswers[index]
            
            let goal = Goal.mr_createEntity()
            if let goal = goal {
                goal.picture = UIImageJPEGRepresentation(thePicture, 1.0)
                goal.question = theQuestion
                goal.example = theExample
                goal.answer = theAnswer
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            }
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
                nextBtn.setTitle("Finished", for: UIControlState())
            }
        }
        
        textView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(PersonalizeGoalsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PersonalizeGoalsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if (index <= 0) {
            previousBtn.isEnabled = false
            previousBtn.alpha = 0.5
        }
        
        previousBtn.layer.cornerRadius = 5.0;
        previousBtn.layer.borderColor = UIColor.gray.cgColor
        previousBtn.layer.borderWidth = 1.5
        
        nextBtn.layer.cornerRadius = 5.0;
        nextBtn.layer.borderColor = UIColor.gray.cgColor
        nextBtn.layer.borderWidth = 1.5
        
        self.title = "Personalizing Goals"
        
        //        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonalizeGoalsViewController.goBack))
        //        backBtn.tintColor = UIColor.whiteColor()
        //        navigationItem.leftBarButtonItem = backBtn
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PersonalizeGoalsViewController.goHome))
        homeBtn.tintColor = UIColor.white
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
            textView.text = "Click here to enter your personalized goal"
            textView.textColor = UIColor.lightGray
            _flag = false
        }
        else {
            textView.textColor = UIColor.black
            _flag = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func keyboardWillShow(_ notification: Notification) {
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        if (theFlag == true) {
            length = self.textView.contentSize.height
            distance = keyboardFrame.size.height - self.textView.frame.height - nextBtn.frame.height + length
        }
        
        scrollView.isScrollEnabled = true
        
        self.scrollView.setContentOffset(CGPoint(x: 0, y: distance), animated: true)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollView.contentInset = contentInset
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)
        scrollView.isScrollEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (self.textView.contentSize.height < textView.frame.height) {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: distance + self.textView.contentSize.height - length), animated: true)
            distance += self.textView.contentSize.height - length
            length = self.textView.contentSize.height
            theFlag = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        _flag = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter your personalized goal here"
            textView.textColor = UIColor.lightGray
            _flag = false
        }
    }
    
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    func goNext(){
        let storyboardIdentifier = "ViewGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
}
