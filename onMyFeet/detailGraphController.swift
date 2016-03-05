//
//  detailGraphController.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-03-05.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class detailGraphController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mTableView: UITableView!
    
    var dailyGraph:GraphView?
    var graphTitle:String!
    var graphPoints: [Int]!
    var dateArray: [String]!
    var category: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        dailyGraph = GraphView(frame: CGRect(x: 8, y: 75, width: UIScreen.mainScreen().bounds.width - 16, height: 200))
        dailyGraph?.backgroundColor = UIColor.whiteColor()
        dailyGraph?.label.text = graphTitle
        dailyGraph?.graphPoints = graphPoints
        dailyGraph?.dateArray = dateArray
        self.view.addSubview(dailyGraph!)
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:Table View
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = mTableView.dequeueReusableCellWithIdentifier("dailyData")!
        cell.textLabel?.text = String(graphPoints[indexPath.row])
        cell.detailTextLabel?.text = dateArray[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graphPoints.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return category
    }
}
