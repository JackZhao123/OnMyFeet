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
    
    let reuserIdentifier = "GoalCell"
    var selectedImages = [UIImage]()
    var flagForPersonalGoal = false
    var setGoalAlertVC: UIAlertController!
    var customizedGoals = [Goal]()
    
    var selectedIndexes = [IndexPath]() {
        didSet {
            countLable.text = "Number of goals selected: \(selectedIndexes.count + customizedGoals.count)"
            collectionView.reloadData()
        }
    }
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setting Goals"
        
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
        collectionView.alpha = 1.0
        collectionView.allowsSelection = true
        countLable.isHidden = false
        
        selectedIndexes.removeAll()
        selectedImages.removeAll()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 17 + self.customizedGoals.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = GoalsCollectionViewCell()
        
        if indexPath.row < 16 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! GoalsCollectionViewCell

            cell.goalImgView.image = UIImage (named: "\(indexPath.row)")
            cell.checkImgView.isHidden = false

            if self.selectedIndexes.index(of: indexPath) == nil {
                cell.setCheckViewImage(selected: false)
            } else {
                cell.setCheckViewImage(selected: true)
            }
            
        } else if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 ) {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuserIdentifier, for: indexPath) as! GoalsCollectionViewCell

            cell.goalImgView.image = UIImage (named: "16")
            cell.checkImgView.isHidden = true
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customized", for: indexPath) as! GoalsCollectionViewCell
            let goal = customizedGoals[indexPath.row - 16]
            cell.checkImgView.isHidden = true
            cell.goalImgView.image = UIImage(data: goal.picture!)
            cell.customizedGoalLabel.text = goal.answer
        }
       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath.row < 16) {
            if let indexSelected = selectedIndexes.index(of: indexPath) {
                selectedIndexes.remove(at: indexSelected)
                selectedImages.remove(at: indexSelected)
                
            } else {
                selectedIndexes.append(indexPath)
                selectedImages.append(UIImage(named: "\(indexPath.row)")!)
                
            }
            
        } else if (indexPath.row == collectionView.numberOfItems(inSection: 0) - 1) {
            flagForPersonalGoal = true
            setPersonalGoal()
        }
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
            let b4 = self.collectionView.bounds
            let b5 = self.selectLabel.bounds
            
            let width = b3.size.width
            let height = b3.size.height
            
            
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
//            let w1 = width / CGFloat(self.selectedImages.count-1)
//            let h1 = b5.size.height+b4.size.height/2+constraintLength.constant*2
            
            let w = b4.size.width - 100
            let w1 = w / CGFloat(self.selectedImages.count-1)
            let h1 = height/2-30
            
            if (self.selectedImages.count == 1) {
                path.move(to: CGPoint (x: width/2, y: h1))
            }else {
                path.move(to: CGPoint (x: (width-w)/2 + w1*CGFloat(i), y: h1))
            }
            
            path.addLine(to: CGPoint(x: width/2, y: height-180))
            
            let anim = CAKeyframeAnimation (keyPath: "position")
            anim.path = path.cgPath
            anim.rotationMode = kCAAnimationRotateAuto
            anim.duration = duration
            anim.timeOffset = delay
            
            goal.layer.add(anim, forKey: "animate position along path")
        }
    }
    
    func setPersonalGoal() {
        setGoalAlertVC = UIAlertController(title: "Add a personal goal that is important to you", message: "", preferredStyle: .alert)
        setGoalAlertVC.addTextField { (textField) -> Void in
            textField.tag = 1
            textField.placeholder = "Enter your personal goal here"
            textField.delegate = self
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler:{ (action) -> Void in
            let thePicture = UIImage(named: "customized-goal")
            let theQuestion = self.setGoalAlertVC.textFields![0].text
            let theExample = self.setGoalAlertVC.textFields![0].text
            let theAnswer = self.setGoalAlertVC.textFields![0].text
            
            let goal = Goal.mr_createEntity()
            if let goal = goal {
                goal.picture = UIImageJPEGRepresentation(thePicture!, 1.0)
                goal.question = theQuestion
                goal.example = theExample
                goal.answer = theAnswer
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                self.customizedGoals.append(goal)
                self.collectionView.reloadData()
            }
            self.countLable.text = "Number of goals selected: \(self.selectedIndexes.count + self.customizedGoals.count)"
        })
            
        saveAction.isEnabled = false
        setGoalAlertVC.addAction(saveAction)
        setGoalAlertVC.addAction(cancelAction)
        
        present(setGoalAlertVC, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1 {
            if string == "" && range.location == 0 {
                setGoalAlertVC.actions[0].isEnabled = false
                
            } else {
                setGoalAlertVC.actions[0].isEnabled = true
            }
        }
        
        return true
    }
    
    //MARK: Actions
    func goBack(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func goHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func deselectAll(_ sender: UIButton) {
        if (selectedIndexes.count != 0) {
            selectedIndexes.removeAll()
            selectedImages.removeAll()
            countLable.text = "Number of goals selected: 0"
        }
    }
    
    @IBAction func finishSelecting(_ sender: UIButton) {
        
        if selectedIndexes.count == 0 {
            //Show alert for not choosing any goals
            if flagForPersonalGoal == false {
                let alert = UIAlertController (title: "Please select your goals", message: "You should select at least 1 goal", preferredStyle: .alert)
                let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            } else {
                goBack()
            }
            
        } else {
            //Proceed to next page
            countLable.isHidden = true
            collectionView.allowsSelection = false
            UIView.animate(withDuration: 0.7, animations: { () -> Void in
                self.deselectAll.alpha = 0.0
                self.finishSelecting.alpha = 0.0
                self.collectionView.alpha = 0.5
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
