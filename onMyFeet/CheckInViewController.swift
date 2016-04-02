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
        
        if NSUserDefaults.standardUserDefaults().boolForKey("NoNeed") == false {
            ClientDataManager.sharedInstance().initQuestionSetData()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "NoNeed")
        }
        
        if let questions = ClientDataManager.sharedInstance().fetchQuestionSet() {
            allQuestionnaire = questions
        }
        
        titleTextView = UITextView(frame: CGRect(x: 8.0, y: 72.0, width: screenWidth - 16, height: 100.0))
        titleTextView.textAlignment = .Justified
        titleTextView.font = UIFont.systemFontOfSize(18.0)
        titleTextView.text = "Are any of these problems affecting your ability to participate in therapy?\n\nSelect all that have been problems for you this week:"
        
        let fixedWidth = titleTextView.frame.size.width
        let newSize = titleTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = titleTextView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        titleTextView.textColor = UIColor.whiteColor()
        titleTextView.backgroundColor = .None
        titleTextView.frame = newFrame;
        titleTextView.userInteractionEnabled = false
        
        let backgroundView = UIView(frame: CGRect(x: 0.0, y: 64.0, width: screenWidth, height: newFrame.origin.y + newSize.height + 8))
        backgroundView.backgroundColor = UIColor(red: (139/255.0), green: (195/255.0), blue: (74/255.0), alpha: 1.0)
        
        buttonTableView = UITableView(frame: CGRect(x: 0.0, y: newFrame.origin.y + newSize.height + 16 , width: screenWidth, height: screenHeight - newFrame.origin.y - 16 - newSize.height))
        buttonTableView.delegate = self
        buttonTableView.dataSource = self
        
        self.view.addSubview(backgroundView)
        self.view.addSubview(buttonTableView)
        self.view.addSubview(titleTextView)

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
        
        let desController = QuestionnaireViewController()
        desController.question = ques
        
        self.navigationController?.pushViewController(desController, animated: true)
        
        buttonTableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
}
