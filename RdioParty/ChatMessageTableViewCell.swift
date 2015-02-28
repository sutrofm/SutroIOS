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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        
        let exclusionFrame = CGRectMake(0, 0, 65, 28)
        let exclusionPath = UIBezierPath(rect: exclusionFrame)
        self.messageText.textContainer.exclusionPaths = [exclusionPath]
    }
    
    override func prepareForReuse() {
        self.layoutSubviews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
