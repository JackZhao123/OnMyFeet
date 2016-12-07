//
//  ChooseGoalsViewController.swift
//  OnMyFeet
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit
import CoreData

class ChooseGoalsViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var personalizeBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var goalsNumLabel: UILabel!
    
    
    let cellIdentifier = "ChooseGoalsCollectionViewCell"
    
    var indexes = [Int]()
    var finalIndexes = [Int]()
    var selectedIndexes = [IndexPath]() {
        didSet {
            self.goalsNumLabel.text = "Number of goals prioritized: \(selectedIndexes.count)"
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
        
        let homeBtn = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ChooseGoalsViewController.goHome))
        homeBtn.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = homeBtn
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        personalizeBtn.layer.cornerRadius = 5.0;
        personalizeBtn.layer.borderColor = UIColor.gray.cgColor
        personalizeBtn.layer.borderWidth = 1.5
        
        initialization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.alpha = 1
        selectedIndexes.removeAll()
        finalIndexes.removeAll()
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return indexes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GoalsCollectionViewCell
        
        let theIndex = indexes[(indexPath as NSIndexPath).item]
        cell.goalImgView.image = pictures[theIndex]
        
        if self.selectedIndexes.index(of: indexPath) == nil {
            cell.setCheckViewImage(selected: false)
        } else {
            cell.setCheckViewImage(selected: true)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let indexSelected = selectedIndexes.index(of: indexPath) {
            selectedIndexes.remove(at: indexSelected)
            
        }else {
            selectedIndexes.append(indexPath)
        }
    }
    
    @IBAction func personalizeBtn(_ sender: UIButton) {
        if (selectedIndexes.count == 0 || selectedIndexes.count > 4) {
            let alert = UIAlertController (title: "", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction (title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            
            if (selectedIndexes.count == 0) {
                alert.title = "Please select your goals"
                alert.message = "You should select at least 1 goal"
                present(alert, animated: true, completion: nil)
            }
            
            if (selectedIndexes.count > 4) {
                alert.title = "More than 4 goals are selected"
                if (selectedIndexes.count == 5) {
                    alert.message = "Please deselect 1 goal"
                    present(alert, animated: true, completion: nil)
                }
                else {
                    alert.message = "Please deselect \(selectedIndexes.count - 4) goals"
                    present(alert, animated: true, completion: nil)
                }
            }
        }

        else {
            
            for index in 0..<selectedIndexes.count {
                finalIndexes.append(indexes[(selectedIndexes[index] as NSIndexPath).row])
            }
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.collectionView.alpha = 0.5
                }, completion: { finished in
                    self.goNext()
            })
        }
    }
    
    func goBack(){
       _ = self.navigationController?.popViewController(animated: true)
    }

    func goHome(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func goNext(){
        let storyboardIdentifier = "PersonalizeGoalsViewController"
        let desController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as! PersonalizeGoalsViewController
        desController.indexes = self.finalIndexes
        self.navigationController!.pushViewController(desController, animated: true)
    }
}
