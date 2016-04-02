//
//  AlarmLabelViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class AlarmLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
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
    
    //MARK: TableView delegate
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = NSBundle.mainBundle().loadNibNamed("LabelCell", owner: self, options: nil).first! as! LabelCell
        
        return cell
    }

}
