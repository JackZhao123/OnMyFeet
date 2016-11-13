//
//  GoalsCollectionViewCell.swift
//  onMyFeet
//
//  Created by apple on 16/2/22.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

class GoalsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkImgView: UIImageView!
    @IBOutlet weak var goalImgView: UIImageView!
    
    let checkImg = UIImage(named: "Check")
    let deselectImg = UIImage(named: "Cross")
    
    func setCheckViewImage(selected: Bool)
    {
        if selected == false {
            self.checkImgView.image = deselectImg
        } else {
            self.checkImgView.image = checkImg
        }
    }
    
}
