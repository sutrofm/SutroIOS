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
    
    @IBOutlet weak var previewImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
