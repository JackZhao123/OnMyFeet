//
//  RepeatCell.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-02.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import UIKit

class RepeatCell: UITableViewCell {
    @IBOutlet weak var repeatImage: UIImageView!
    @IBOutlet weak var repeatLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
