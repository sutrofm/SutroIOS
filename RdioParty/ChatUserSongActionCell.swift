//
//  ChatUserSongActionCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatUserSongActionCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clearColor()
        self.contentView.layer.cornerRadius = 5.0
        
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
