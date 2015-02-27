//
//  RoomListTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/25/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class RoomListTableViewCell: UITableViewCell {

    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var colorShield: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userCountLabel.layer.cornerRadius = self.userCountLabel.frame.size.width / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            self.colorShield.alpha = 1.0
        } else {
            self.colorShield.alpha = 0.8
        }
        
        // Configure the view for the selected state
    }

}
