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
    @IBOutlet weak var backingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backingView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        
        self.clipsToBounds = true
        self.backingView.layer.cornerRadius = 10.0
        
        // Live hack: I set the color here instead of in IB so I can see the labels in IB
        self.artistName.textColor = UIColor.whiteColor()
        self.trackName.textColor = UIColor.whiteColor()
    }

    override func prepareForReuse() {
        self.backingView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
