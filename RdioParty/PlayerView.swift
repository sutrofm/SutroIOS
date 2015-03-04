//
//  PlayerView.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    class func instanceFromNib() -> PlayerView {
        return UINib(nibName: "PlayerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! PlayerView
    }
    
    override func awakeFromNib() {

//        self.image.layer.mask = gradient
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var gradient = CAGradientLayer()
        gradient.frame = self.image.bounds
        gradient.colors = [ UIColor.clearColor().CGColor, UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor]
        self.image.layer.addSublayer(gradient)
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
