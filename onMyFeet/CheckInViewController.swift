//
//  CheckInViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-10.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var titleTextView: UITextView!
    var buttonTableView: UITableView!
    var allQuestionnaire: [QuestionSet] = [QuestionSet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuestionnaire.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = buttonTableView.dequeueReusableCell(withIdentifier: "buttonCell")
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "buttonCell")
        }
        let q = allQuestionnaire[(indexPath as NSIndexPath).row]
        let ques = NSKeyedUnarchiver.unarchiveObject(with: q.questionnaire! as Data) as! Questionnaire
        cell?.textLabel?.text = q.symptom
        cell?.detailTextLabel?.text = "\(ques.questionSet.count)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let q = allQuestionnaire[(indexPath as NSIndexPath).row]
        let ques = NSKeyedUnarchiver.unarchiveObject(with: q.questionnaire! as Data) as! Questionnaire
        
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "questionView") as! QuestionnaireViewController
        desController.question = ques
        desController.questionTitle = q.title
        
        self.navigationController?.pushViewController(desController, animated: true)
        
        buttonTableView.cellForRow(at: indexPath)?.isSelected = false
    }
}
