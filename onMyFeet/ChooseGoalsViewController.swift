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
    var selectedIndexes = [NSIndexPath]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var goal: Goal!
    var pictures = [UIImage]()
    var questions = [String]()
    var examples = [String]()
    var answers = [String]()
    
    var flagExamples = [String]()
    
    func initialization() {
        for index in 0...15 {
            pictures.append(UIImage (named: "\(index)")!)
        }
        questions = ["Who do you spend time with? What do you typically do together?", "What do you do that you enjoy or is important to you?", "How does this fit in your life?", "What kinds of outdoor activities do you enjoy?", "What kinds of exercise do you enjoy?", "How does this fit in your life?", "How does this fit in your life?", "Where do you like to go?", "How does this fit in your life", "Where do you like to go?", "Where do you like to go?", "How does this fit in your life?", "How does this fit in your life?", "Do you enjoy movies or plays? How does this fit in your life?", "How does this fit in your life?", "Where do you shop? What is important about shopping?"]
        examples = ["For example, \"Going to the coffee shop with my friend Bill.\"", "For example, \"Pruning the bushes in front of my house.\"", "For example, \"Helping in the reading program at the library.\"", "For example, \"Going on walks in the park.\"", "For example, \"Going to the pool to swim laps.\"", "For example, \"Attending weekly service at my church.", "For example, \"Walking my dog.", "For example, \"Visiting my daughter in Vancouver.", "For example, \"Cooking for my daughter.\"", "For example, \"Going to a baseball game.\"", "For example, \"Going to the symphony.\"", "For example, \"Taking the bus to the casino.\"", "For example, \"Getting my hair done at the salon.\"", "For example, \"Going to the movie theatre with my husband.\"", "For example, \"Having brunch at my local diner.\"", "For example, \"Picking out fresh produce at the grocery store.\""]
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Prioritizing Goals"
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: "goHome")
        homeBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = homeBtn
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        personalizeBtn.layer.cornerRadius = 5.0;
        personalizeBtn.layer.borderColor = UIColor.grayColor().CGColor
        personalizeBtn.layer.borderWidth = 1.5
        
        initialization()
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
            if let appDel = UIApplication.sharedApplication().delegate as? AppDelegate {
                let managedObjectContext = appDel.managedObjectContext
                
                for index in 0..<selectedIndexes.count {
                    let theIndex = indexes[selectedIndexes[index].row]
                    let thePicture = pictures[theIndex]
                    let theQuestion = questions[theIndex]
                    let theExample = examples[theIndex]
                    
                    self.flagExamples.append(theExample)
  
                    GoalDataManager().insertGoalData(managedObjectContext, picture: thePicture, question: theQuestion, example: theExample, answer: "")
                }
                
                GoalDataManager().save(managedObjectContext)
            }
            goNext()
        }
    }
    
    func goBack(){
        let storyboardIdentifier = "GoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }

    func goHome(){
//        let storyboardIdentifier = "Menu"
//        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
//        self.navigationController!.pushViewController(desController, animated: true)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func goNext(){
        let storyboardIdentifier = "PersonalizeGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! PersonalizeGoalsViewController
        desController.indexes = self.indexes
        desController.flagExamples = self.flagExamples
        print(desController.flagExamples)
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
    

}
