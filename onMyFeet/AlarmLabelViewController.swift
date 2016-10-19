//
//  AlarmLabelViewController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
protocol AlarmLabelViewControllerDelegate {
    func labelViewDidPopUp(_ labelText:String?)
}

class AlarmLabelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mTableView: UITableView!
    
    var initText:String!
    var delegate:AlarmLabelViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Label"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let index = IndexPath(row: 0, section: 0)
        let cell = mTableView.cellForRow(at: index) as! LabelCell
        let text = cell.mTextField.text
        
        if let delegate = delegate {
                delegate.labelViewDidPopUp(text)
        }
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 180
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)?.first! as! LabelCell
        cell.mTextField.text = initText
        
        return cell
    }

}
