//
//  SongAddedChatTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class SongAddedChatTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
