//
//  ViewGoalsTableViewCell.swift
//  OnMyFeet
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 OnMyFeet Group. All rights reserved.
//

import UIKit

class ViewGoalsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var theImage: UIImageView!
    @IBOutlet weak var theLabel: UITextView!
    


    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.theLabel.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    

}
