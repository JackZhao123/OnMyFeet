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
    
    

    @IBAction func deselectAll(_ sender: UIButton) {
        if (selectedIndexes.count != 0) {
            selectedIndexes.removeAll()
            selectedImages.removeAll()
            countLable.text = "Number of goals selected: 0"
        }
    }
    @IBAction func finishSelecting(_ sender: UIButton) {
        
        if ((selectedIndexes.count == 0) && (flagForPersonalGoal == false)) {
            let alert = UIAlertController (title: "Please select your goals", message: "You should select at least 1 goal", preferredStyle: .alert)
            let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
            
        if ((selectedIndexes.count == 0) && (flagForPersonalGoal != false)) {
            goBack()
        }
        else {
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.deselectAll.alpha = 0.0
                self.finishSelecting.alpha = 0.0
                self.BoxView.alpha = 1.0
                }, completion: { finished in
                    
                    UIView.animate(withDuration: 2.0, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                        self.animation()
                        }, completion: { finished in
                            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                                self.BoxView.alpha = 0.0
                                self.prioritizeThem.alpha = 1.0
                                }, completion: { finished in
                                    self.prioritizeThem.isEnabled = true
                            })
                    })
            })
        }
    }
    
    
    let reuserIdentifier = "GoalCell"
    var selectedImages = [UIImage]()
    var selectedIndexes = [IndexPath]() {
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
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(GoalsViewController.goHome))
        homeBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = homeBtn

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        deselectAll.layer.cornerRadius = 5.0;
        deselectAll.layer.borderColor = UIColor.gray.cgColor
        deselectAll.layer.borderWidth = 1.5
        
        finishSelecting.layer.cornerRadius = 5.0;
        finishSelecting.layer.borderColor = UIColor.gray.cgColor
        finishSelecting.layer.borderWidth = 1.5
        
        prioritizeThem.layer.cornerRadius = 5.0;
        prioritizeThem.layer.borderColor = UIColor.gray.cgColor
        prioritizeThem.layer.borderWidth = 1.5
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        BoxView.alpha = 0.0
        prioritizeThem.alpha = 0.0
        deselectAll.alpha = 1.0
        finishSelecting.alpha = 1.0
        
        
        selectedIndexes.removeAll()
        selectedImages.removeAll()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! GoalsCollectionViewCell
        
        cell.goalImgView.image = UIImage (named: "\((indexPath as NSIndexPath).item)")
        
        if self.selectedIndexes.index(of: indexPath) == nil {
            cell.setCheckViewImage(selected: false)
        } else {
            cell.setCheckViewImage(selected: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if ((indexPath as NSIndexPath).row != 16) {
            if let indexSelected = selectedIndexes.index(of: indexPath) {
                selectedIndexes.remove(at: indexSelected)
                selectedImages.remove(at: indexSelected)
                goalsNum -= 1
                
            }else {
                selectedIndexes.append(indexPath)
                selectedImages.append(UIImage(named: "\((indexPath as NSIndexPath).item)")!)
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
            
            
            
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: UIViewKeyframeAnimationOptions.calculationModePaced, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                    goal.transform = CGAffineTransform (rotationAngle: 1/3 * fullRotation)
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                    goal.transform = CGAffineTransform (rotationAngle: 2/3 * fullRotation)
                })
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                    goal.transform = CGAffineTransform (rotationAngle: 3/3 * fullRotation)
                })
                }, completion: { finished in
                    goal.bounds = CGRect(x: b1.origin.x, y: b1.origin.y, width: 0, height: 0)
                    
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 5, options: .allowAnimatedContent, animations: {
                        self.BoxView.bounds = CGRect(x: b2.origin.x - 20, y: b2.origin.y - 20, width: b2.size.width + 30, height: b2.size.height + 30)
                        }, completion: { finished in
                            self.BoxView.bounds = CGRect (x: b2.origin.x, y: b2.origin.y, width: b2.size.width, height: b2.size.width)
                    })
                    
            })
            
            let path = UIBezierPath()
            let w1 = width / CGFloat(self.selectedImages.count-1)
            let h1 = b5.size.height+b4.size.height/2+constraintLength.constant*2
            
            if (self.selectedImages.count == 1) {
                path.move(to: CGPoint (x: width/2, y: h1))
            }else {
                path.move(to: CGPoint (x: w1*CGFloat(i), y: h1))
            }
            
            path.addLine(to: CGPoint(x: width/2, y: height-150))
            
            let anim = CAKeyframeAnimation (keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.duration = duration
            anim.timeOffset = delay
            
            goal.layer.add(anim, forKey: "animate position along path")
            
        }

    }
    
    func setPersonalGoal() {
        let setGoal = UIAlertController(title: "Add a personal goal that is important to you", message: "", preferredStyle: .alert)
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        setGoal.addTextField { (textField) -> Void in
            textField.placeholder = "Enter your personal goal here"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler:{ (action) -> Void in
            let thePicture = UIImage(named: "noImage")
            let theQuestion = setGoal.textFields![0].text
            let theExample = setGoal.textFields![0].text
            let theAnswer = setGoal.textFields![0].text
            if ((theAnswer!.isEmpty) == true) {
                alert.title = "Please enter your personal goal"
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let goal = Goal.mr_createEntity()
                if let goal = goal {
                    goal.picture = UIImageJPEGRepresentation(thePicture!, 1.0)
                    goal.question = theQuestion
                    goal.example = theExample
                    goal.answer = theAnswer
                    NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                }
                self.goalsNum += 1
                self.countLable.text = "Number of goals selected: " + String(self.goalsNum)
            }
        })
        
        alert.addAction(cancelAction)
        setGoal.addAction(saveAction)
        setGoal.addAction(cancelAction)
        present(setGoal, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PrioritizeGoals" {
            if let des = segue.destination as? ChooseGoalsViewController {
                for index in 0..<selectedIndexes.count {
                    des.indexes.append((selectedIndexes[index] as NSIndexPath).item)
                }
            }
        }
    }

}
