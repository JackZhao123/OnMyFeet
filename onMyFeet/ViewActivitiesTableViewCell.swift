//
//  ViewActivitesTableViewCell.swift
//  onMyFeet
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

protocol ViewActivitesTableViewCellDelegate: class {
    func deleteBtnDidTapped(_ idx: IndexPath)
}

class ViewActivitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var theSlider: GradientSlider!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var programBtn: UIButton!    
    @IBOutlet weak var deleteBtn: UIButton!
    
    var currentIdx: IndexPath?
    weak var delegate: ViewActivitesTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        deleteBtn.layer.cornerRadius = 5.0
        deleteBtn.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        if let delegate = delegate {
            if let currentIdx = currentIdx {
                delegate.deleteBtnDidTapped(currentIdx)
            }
        }
    }

}
