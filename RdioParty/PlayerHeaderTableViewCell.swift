//
//  PlayerHeaderTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/6/15.
//

import UIKit

class PlayerHeaderTableViewCell: UITableViewCell {

    var gradient = CAGradientLayer()

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
        gradient.colors = [ UIColor.clearColor().CGColor, UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor]
        if (self.gradient.superlayer == nil) {
            self.layer.insertSublayer(self.gradient, atIndex: 0)
        }
    }

}
