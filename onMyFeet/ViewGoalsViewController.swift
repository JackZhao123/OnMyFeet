//
//  ViewGoalsViewController.swift
//  OnMyFeet
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData
import MagicalRecord


class ViewGoalsViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var goalTable: UITableView!
    var setGoalsView: UIView!
    var goals: [Goal]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "My Goals"

        goalTable.delegate = self
        goalTable.dataSource = self
        
        let nextBtn = UIBarButtonItem(title: "Add Goals", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ViewGoalsViewController.goNext))
        nextBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = nextBtn
        
        setGoalsView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        setGoalsView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
        self.view.addSubview(setGoalsView)
        
        let instructionLabel = UILabel(frame: CGRect(x: 0, y: (setGoalsView.height - 40) / 2 - 20, width: setGoalsView.width, height: 45))
        instructionLabel.font = UIFont.systemFont(ofSize: 18)
        instructionLabel.numberOfLines = 2
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = UIColor.white
        instructionLabel.text = "You don't have any goals\nPlease add goals to contiune."
        setGoalsView.addSubview(instructionLabel)
        
        let goalsBtn = UIButton(frame: CGRect(x: (setGoalsView.width - 235) / 2, y: instructionLabel.bottom + 10, width: 235, height: 35))
        goalsBtn.backgroundColor = UIColor.defaultGreenColor()
        goalsBtn.addTarget(self, action: #selector(self.goNext), for: .touchUpInside)
        goalsBtn.setTitle("Click here to set goals", for: .normal)
        goalsBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        goalsBtn.layer.cornerRadius = 5.0
        setGoalsView.addSubview(goalsBtn)
        
        goals = Goal.mr_findAll() == nil ? [Goal]() : Goal.mr_findAll() as! [Goal]
        
        goalTable.isHidden = goals.count == 0 ? true : false
        setGoalsView.isHidden = !goalTable.isHidden
    }
    
    override func viewWillAppear(_ animated: Bool) {
        goals = Goal.mr_findAll() == nil ? [Goal]() : Goal.mr_findAll() as! [Goal]
        goalTable.setContentOffset(CGPoint.zero, animated: true)
        goalTable.reloadData()
        
        goalTable.isHidden = goals.count == 0 ? true : false
        setGoalsView.isHidden = !goalTable.isHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewActivities" {
            if let des = segue.destination as? ViewActivitiesViewController {
                if let selectedGoalCell = sender as? ViewGoalsTableViewCell {
                    if let indexPath: IndexPath = self.goalTable.indexPath(for: selectedGoalCell) {
                        
                        let selectedGoal = goals[(indexPath as NSIndexPath).row]
                        des.theGoal = selectedGoal
                    }
                }
            }
        }
    }
    
    //MARK: TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ViewGoalsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ViewGoalsTableViewCell
        
        let goal = goals[(indexPath as NSIndexPath).row]
        
        cell.theImage.image = UIImage(data: goal.picture! as Data)
        cell.theLabel.setContentOffset(CGPoint.zero, animated: false)
        cell.theLabel.text = goal.answer
        cell.theLabel.delegate = self
        
        return cell
    }
    
    
//    func textViewDidBeginEditing(textView: UITextView) {
//        let point = textView.convertPoint(textView.bounds.origin, toView: self.goalTable)
//        let indexPath = self.goalTable.indexPathForRowAtPoint(point)
//        self.goalTable.scrollToRowAtIndexPath(indexPath!, atScrollPosition: .Middle, animated: true)
//        print(indexPath)
//    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        let point = textView.convert(textView.bounds.origin, to: self.goalTable)
//        let index = (self.goalTable.indexPathForRow(at: point) as NSIndexPath?)?.row
//        let theGoal = goals[index!]
//        
//        theGoal.answer = textView.text
//        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
//    }
//    
//    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
//        return true
//    }
    
    //MARK: TableViewDelegate
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.goals[(indexPath as NSIndexPath).row].mr_deleteEntity()
//            goals.remove(at: (indexPath as NSIndexPath).row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            if (goals.count == 0) {
//                goalTable.isHidden = true
//                setGoalsBtn.isHidden = false
//                setGoalsBtn.isEnabled = true
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.view.frame.height > self.view.frame.width) {
            let theHeight = self.goalTable.frame.height / CGFloat(4)
            return theHeight
        }
        else {
            return 140
        }
    }

    //MARK: ButtonAction
    @IBAction func setGoalsAction(_ sender: UIButton) {
        goNext()
    }
    
    func goBack(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goNext(){
        let storyboardIdentifier = "GoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }
}
