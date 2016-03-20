//
//  GoalsViewController.swift
//  onMyFeet
//
//  Created by Zhao Xiongbin on 2016-02-22.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class GoalsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: Properties
    

    @IBOutlet var goalView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var BoxView: UIImageView!
    @IBOutlet weak var deselectAll: UIButton!
    @IBOutlet weak var finishSelecting: UIButton!
    @IBOutlet weak var prioritizeThem: UIButton!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var constraintLength: NSLayoutConstraint!
    
    

    @IBAction func deselectAll(sender: UIButton) {
        if (selectedIndexes.count != 0) {
            selectedIndexes.removeAll()
            selectedImages.removeAll()
        }
    }
    @IBAction func finishSelecting(sender: UIButton) {
        
        if (selectedIndexes.count == 0) {
            let alert = UIAlertController (title: "Please select your goals", message: "You should select at least 1 goal", preferredStyle: .Alert)
            let cancelAction = UIAlertAction (title: "Cancel", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion: nil)
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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting Goals"
        
        let backBtn = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = backBtn
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: "goHome")
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
        
        BoxView.alpha = 0.0
        prioritizeThem.alpha = 0.0
        prioritizeThem.enabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
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
        
        if let indexSelected = selectedIndexes.indexOf(indexPath) {
            selectedIndexes.removeAtIndex(indexSelected)
            selectedImages.removeAtIndex(indexSelected)
            
        }else {
            selectedIndexes.append(indexPath)
            selectedImages.append(UIImage(named: "\(indexPath.item)")!)
        }
    }
    
    //MARK: Animations
    func animation() {
        
        for var i = 0; i < self.selectedImages.count; ++i {
            
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
    
    
    //MARK: Actions
    func goBack(){
        let storyboardIdentifier = "ViewGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
        self.navigationController!.pushViewController(desController, animated: true)
    }
    
    func goHome(){
//        let storyboardIdentifier = "Menu"
//        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier)
//        self.navigationController!.pushViewController(desController, animated: true)
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
