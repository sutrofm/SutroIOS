//
//  QueueItemCellTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class QueueItemCellTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackArtist: UILabel!
    @IBOutlet weak var userAddedLabel: UILabel!
    @IBOutlet weak var trackLength: UILabel!
    
    @IBOutlet weak var voteUpButton: UIButton!
    @IBOutlet weak var voteDownButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func upVoteButtonPressed(sender: AnyObject) {
    }


    @IBAction func downVoteButtonPressed(sender: AnyObject) {
    }
}
