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
        self.contentView.backgroundColor = UIColor.blackColor()
        
        self.contentView.clipsToBounds = true
        self.clipsToBounds = true
        
        self.userCountLabel.clipsToBounds = true
        self.userCountLabel.layer.cornerRadius = self.userCountLabel.frame.size.width / 2
        
        self.nameLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.nameLabel.layer.shadowOffset = CGSizeMake(1, 1)
        self.nameLabel.layer.shadowRadius = 3.0
        self.nameLabel.layer.shadowOpacity = 0.5
        
        self.themeLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.themeLabel.layer.shadowOffset = CGSizeMake(1, 1)
        self.themeLabel.layer.shadowRadius = 3.0
        self.themeLabel.layer.shadowOpacity = 0.5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            self.colorShield.alpha = 0.4
            self.nameLabel.layer.shadowOpacity = 0.1
        } else {
            self.colorShield.alpha = 0.2
            self.nameLabel.layer.shadowOpacity = 0.5
        }
        
        // Configure the view for the selected state
    }

}
