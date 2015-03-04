//
//  ChatMessageTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/25/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageText: ChatMessageContentTextView!
    @IBOutlet weak var backingView: CutOutView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.messageText.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.messageText.backgroundColor = UIColor.clearColor()

        // This is the area that the user icon takes up on top of the cell, so we make
        // the text "wrap" around it.
        let exclusionFrame = CGRectMake(0, 0, 42, 20)
        let exclusionPath = UIBezierPath(rect: exclusionFrame)
        self.messageText.textContainer.exclusionPaths = [exclusionPath]

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
