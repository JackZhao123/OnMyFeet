//
//  AlarmLabelViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
protocol AlarmLabelViewControllerDelegate {
    func labelViewDidPopUp(labelText:String?)
}

class AlarmLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    var initText:String!
    var delegate:AlarmLabelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = "Label"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        let index = NSIndexPath(forRow: 0, inSection: 0)
        let cell = mTableView.cellForRowAtIndexPath(index) as! LabelCell
        let text = cell.mTextField.text
        
        if let delegate = delegate {
                delegate.labelViewDidPopUp(text)
        }
    }
    
    //MARK: TableView delegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("LabelCell", owner: self, options: nil).first! as! LabelCell
        cell.mTextField.text = initText
        
        return cell
    }

}
