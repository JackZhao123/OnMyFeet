//
//  GoalsViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-22.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class GoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet var goalView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BoxView: UIImageView!
    @IBOutlet weak var deselectAll: UIButton!
    @IBOutlet weak var finishSelecting: UIButton!
    @IBOutlet weak var prioritizeThem: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var constraintLength: NSLayoutConstraint!
    @IBOutlet weak var countLable: UILabel!
    
    

    @IBAction func deselectAll(sender: UIButton) {
        if (selectedIndexes.count != 0) {
            selectedIndexes.removeAll()
            selectedImages.removeAll()
            countLable.text = "Number of goals selected: 0"
        }
    }
    @IBAction func finishSelecting(sender: UIButton) {
        
        if ((selectedIndexes.count == 0) && (flagForPersonalGoal == false)) {
            let alert = UIAlertController (title: "Please select your goals", message: "You should select at least 1 goal", preferredStyle: .Alert)
            let cancelAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
        }
            
        if ((selectedIndexes.count == 0) && (flagForPersonalGoal != false)) {
            goBack()
        }
        
        else {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.deselectAll.alpha = 0.0
                self.finishSelecting.alpha = 0.0
                self.BoxView.alpha = 1.0
                }, completion: { finished in
                    
                    UIView.animateWithDuration(2.0, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
                        self.animation()
                        }, completion: { finished in
                            UIView.animateWithDuration(0.5, animations: { () -> Void in
                                self.BoxView.alpha = 0.0
                                self.prioritizeThem.alpha = 1.0
                                }, completion: { finished in
                                    self.prioritizeThem.enabled = true
                            })
                    })
            })
        }
    }
    
    
    let reuserIdentifier = "GoalCell"
    var selectedImages = [UIImage]()
    var selectedIndexes = [NSIndexPath]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var flagForPersonalGoal = false
    var goalsNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting Goals"
        
//        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(GoalsViewController.goBack))
//        backBtn.tintColor = UIColor.whiteColor()
//        navigationItem.leftBarButtonItem = backBtn
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(GoalsViewController.goHome))
        homeBtn.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = homeBtn

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        deselectAll.layer.cornerRadius = 5.0;
        deselectAll.layer.borderColor = UIColor.grayColor().CGColor
        deselectAll.layer.borderWidth = 1.5
        
        finishSelecting.layer.cornerRadius = 5.0;
        finishSelecting.layer.borderColor = UIColor.grayColor().CGColor
        finishSelecting.layer.borderWidth = 1.5
        
        prioritizeThem.layer.cornerRadius = 5.0;
        prioritizeThem.layer.borderColor = UIColor.grayColor().CGColor
        prioritizeThem.layer.borderWidth = 1.5
        
        self.navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        BoxView.alpha = 0.0
        prioritizeThem.alpha = 0.0
        deselectAll.alpha = 1.0
        finishSelecting.alpha = 1.0
        
        
        selectedIndexes.removeAll()
        selectedImages.removeAll()
        collectionView.setContentOffset(CGPointZero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuserIdentifier, forIndexPath: indexPath) as! GoalsCollectionViewCell
        
        cell.GoalPicture.image = UIImage (named: "\(indexPath.item)")
        
        if self.selectedIndexes.indexOf(indexPath) == nil {
            cell.CheckView.hidden = true
        } else {
            cell.CheckView.hidden = false
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row != 16) {
            if let indexSelected = selectedIndexes.indexOf(indexPath) {
                selectedIndexes.removeAtIndex(indexSelected)
                selectedImages.removeAtIndex(indexSelected)
                goalsNum -= 1
                
            }else {
                selectedIndexes.append(indexPath)
                selectedImages.append(UIImage(named: "\(indexPath.item)")!)
                goalsNum += 1
            }
        }
        
        else {
            flagForPersonalGoal = true
            setPersonalGoal()
        }
        
        countLable.text = "Number of goals selected: " + String(goalsNum)
    }
    
    //MARK: Animations
    func animation() {
        
        for i in 0..<self.selectedImages.count {
            
            let goal = UIImageView()
            let b1 = goal.bounds
            var b2 = self.BoxView.bounds
            b2.size.width = 120
            b2.size.height = 120
            let b3 = self.goalView.bounds
            let width = b3.size.width
            let height = b3.size.height
            let b4 = self.collectionView.bounds
            let b5 = self.selectLabel.bounds
            
            
            goal.image = self.selectedImages[i]
            goal.frame = CGRect (x: width/2, y: height-150, width: 100, height: 75)
            self.view.addSubview (goal)
            
            let fullRotation = CGFloat(M_PI * 2)
            let duration = 2.0
            let delay = 0.0
            
            
            
            UIView.animateKeyframesWithDuration(duration, delay: delay, options: UIViewKeyframeAnimationOptions.CalculationModePaced, animations: {
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                    goal.transform = CGAffineTransformMakeRotation (1/3 * fullRotation)
                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                    goal.transform = CGAffineTransformMakeRotation (2/3 * fullRotation)
                })
                UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0, animations: {
                    goal.transform = CGAffineTransformMakeRotation (3/3 * fullRotation)
                })
                }, completion: { finished in
                    goal.bounds = CGRect(x: b1.origin.x, y: b1.origin.y, width: 0, height: 0)
                    
                    UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .AllowAnimatedContent, animations: {
                        self.BoxView.bounds = CGRect(x: b2.origin.x - 20, y: b2.origin.y - 20, width: b2.size.width + 30, height: b2.size.height + 30)
                        }, completion: { finished in
                            self.BoxView.bounds = CGRect (x: b2.origin.x, y: b2.origin.y, width: b2.size.width, height: b2.size.width)
                    })
                    
            })
            
            let path = UIBezierPath()
            let w1 = width / CGFloat(self.selectedImages.count-1)
            let h1 = b5.size.height+b4.size.height/2+constraintLength.constant*2
            
            if (self.selectedImages.count == 1) {
                path.moveToPoint(CGPoint (x: width/2, y: h1))
            }else {
                path.moveToPoint(CGPoint (x: w1*CGFloat(i), y: h1))
            }
            
            path.addLineToPoint(CGPoint(x: width/2, y: height-150))
            
            let anim = CAKeyframeAnimation (keyPath: "position")
            anim.path = path.CGPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.duration = duration
            anim.timeOffset = delay
            
            goal.layer.addAnimation (anim, forKey: "animate position along path")
            
        }

    }
    
    func setPersonalGoal() {
        let setGoal = UIAlertController(title: "Add a personal goal that is important to you", message: "", preferredStyle: .Alert)
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .Alert)
        setGoal.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Enter your personal goal here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler:{ (action) -> Void in
            let thePicture = UIImage(named: "noImage")
            let theQuestion = setGoal.textFields![0].text
            let theExample = setGoal.textFields![0].text
            let theAnswer = setGoal.textFields![0].text
            if ((theAnswer!.isEmpty) == true) {
                alert.title = "Please enter your personal goal"
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                let goal = Goal.MR_createEntity()
                if let goal = goal {
                    goal.picture = UIImageJPEGRepresentation(thePicture!, 1.0)
                    goal.question = theQuestion
                    goal.example = theExample
                    goal.answer = theAnswer
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                }
                self.goalsNum += 1
                self.countLable.text = "Number of goals selected: " + String(self.goalsNum)
            }
        })
        
        alert.addAction(cancelAction)
        setGoal.addAction(saveAction)
        setGoal.addAction(cancelAction)
        presentViewController(setGoal, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goHome(){
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    
    //MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PrioritizeGoals" {
            if let des = segue.destinationViewController as? ChooseGoalsViewController {
                for index in 0..<selectedIndexes.count {
                    des.indexes.append(selectedIndexes[index].item)
                }
            }
        }
    }

}
