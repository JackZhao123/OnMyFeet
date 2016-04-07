//
//  ChooseGoalsViewController.swift
//  OnMyFeet
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ChooseGoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var personalizeBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    let cellIdentifier = "ChooseGoalsCollectionViewCell"
    
    var indexes = [Int]()
    var finalIndexes = [Int]()
    var selectedIndexes = [NSIndexPath]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var pictures = [UIImage]()
    
    func initialization() {
        for index in 0...15 {
            pictures.append(UIImage (named: "\(index)")!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Prioritizing Goals"
        
//        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseGoalsViewController.goBack))
//        backBtn.tintColor = UIColor.whiteColor()
//        navigationItem.leftBarButtonItem = backBtn
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseGoalsViewController.goHome))
        homeBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = homeBtn
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        personalizeBtn.layer.cornerRadius = 5.0;
        personalizeBtn.layer.borderColor = UIColor.grayColor().CGColor
        personalizeBtn.layer.borderWidth = 1.5
        
        initialization()
    }
    
    override func viewWillAppear(animated: Bool) {
        selectedIndexes.removeAll()
        finalIndexes.removeAll()
        collectionView.setContentOffset(CGPointZero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexes.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! ChooseGoalsCollectionViewCell
        
        let theIndex = indexes[indexPath.item]
        cell.imageView.image = pictures[theIndex]
        
        if self.selectedIndexes.indexOf(indexPath) == nil {
            cell.checkView.hidden = true
        } else {
            cell.checkView.hidden = false
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let indexSelected = selectedIndexes.indexOf(indexPath) {
            selectedIndexes.removeAtIndex(indexSelected)
            
        }else {
            selectedIndexes.append(indexPath)
        }
    }
    
    @IBAction func personalizeBtn(sender: UIButton) {
        if (selectedIndexes.count == 0 || selectedIndexes.count > 4) {
            let alert = UIAlertController (title: "", message: "", preferredStyle: .Alert)
            let cancelAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            
            if (selectedIndexes.count == 0) {
                alert.title = "Please select your goals"
                alert.message = "You should select at least 1 goal"
                presentViewController(alert, animated: true, completion: nil)
            }
            
            if (selectedIndexes.count > 4) {
                alert.title = "More than 4 goals are selected"
                if (selectedIndexes.count == 5) {
                    alert.message = "Please deselect 1 goal"
                    presentViewController(alert, animated: true, completion: nil)
                }
                else {
                    alert.message = "Please deselect \(selectedIndexes.count - 4) goals"
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
        }

        else {
            
            for index in 0..<selectedIndexes.count {
                finalIndexes.append(indexes[selectedIndexes[index].row])
            }
            
            goNext()
        }
    }
    
    func goBack(){
       self.navigationController?.popViewControllerAnimated(true)
    }

    func goHome(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goNext(){
        let storyboardIdentifier = "PersonalizeGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! PersonalizeGoalsViewController
        desController.indexes = self.finalIndexes
        self.navigationController!.pushViewController(desController, animated: true)
    }
}
