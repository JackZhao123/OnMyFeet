//
//  CheckInViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var titleTextView: UITextView!
    var buttonTableView: UITableView!
    var allQuestionnaire: [QuestionSet] = [QuestionSet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        var questions: [QuestionSet]?

        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            if NSUserDefaults.standardUserDefaults().boolForKey("NoNeed") == false {
                ClientDataManager.sharedInstance().initQuestionSetData()
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NoNeed")
            }
            dispatch_async(dispatch_get_main_queue()) {
                questions = ClientDataManager.sharedInstance().fetchQuestionSet()
                if let questions = questions {
                    self.allQuestionnaire = questions
                }
                
                self.titleTextView = UITextView(frame: CGRect(x: 8.0, y: 72.0, width: self.screenWidth - 16, height: 100.0))
                self.titleTextView.textAlignment = .Justified
                self.titleTextView.font = UIFont.systemFontOfSize(18.0)
                self.titleTextView.text = "Are any of these problems affecting your ability to participate in therapy?\n\nSelect all that have been problems for you this week:"
                
                let fixedWidth = self.titleTextView.frame.size.width
                let newSize = self.titleTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
                var newFrame = self.titleTextView.frame
                newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
                self.titleTextView.textColor = UIColor.whiteColor()
                self.titleTextView.backgroundColor = .None
                self.titleTextView.frame = newFrame;
                self.titleTextView.userInteractionEnabled = false
                
                let backgroundView = UIView(frame: CGRect(x: 0.0, y: 64.0, width: self.screenWidth, height: newFrame.origin.y + newSize.height + 8))
                backgroundView.backgroundColor = UIColor(red: (139/255.0), green: (195/255.0), blue: (74/255.0), alpha: 1.0)
                
                self.buttonTableView = UITableView(frame: CGRect(x: 0.0, y: newFrame.origin.y + newSize.height + 16 , width: self.screenWidth, height: self.screenHeight - newFrame.origin.y - 16 - newSize.height))
                self.buttonTableView.delegate = self
                self.buttonTableView.dataSource = self
                
                self.view.addSubview(backgroundView)
                self.view.addSubview(self.buttonTableView)
                self.view.addSubview(self.titleTextView)
            }
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestionnaire.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = buttonTableView.dequeueReusableCellWithIdentifier("buttonCell")
        if cell == nil {
            cell = UITableViewCell(style: .Value1, reuseIdentifier: "buttonCell")
        }
        let q = allQuestionnaire[indexPath.row]
        let ques = NSKeyedUnarchiver.unarchiveObjectWithData(q.questionnaire!) as! Questionnaire
        cell?.textLabel?.text = q.symptom
        cell?.detailTextLabel?.text = "\(ques.questionSet.count)"
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let q = allQuestionnaire[indexPath.row]
        let ques = NSKeyedUnarchiver.unarchiveObjectWithData(q.questionnaire!) as! Questionnaire
        
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("questionView") as! QuestionnaireViewController
        desController.question = ques
        desController.questionTitle = q.title
        
        self.navigationController?.pushViewController(desController, animated: true)
        
        buttonTableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
}
