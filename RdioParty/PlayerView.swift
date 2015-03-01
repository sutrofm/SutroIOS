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
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PlayerView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
