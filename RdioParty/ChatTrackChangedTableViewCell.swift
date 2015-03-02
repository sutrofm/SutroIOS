//
//  ChatTrackChangedTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatTrackChangedTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        
        self.clipsToBounds = true
        self.contentView.layer.cornerRadius = 10.0
    }

    override func prepareForReuse() {
        self.contentView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }
    
     override func layoutSubviews() {
//        self.trackImage.clipsToBounds = true
//        self.trackImage.layer.cornerRadius = self.trackImage.frame.size.width / 2
//        
//        self.userImage.clipsToBounds = true
//        self.userImage.layer.cornerRadius = 4
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
