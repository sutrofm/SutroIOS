//
//  RPTabBar.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class RPTabBar: UITabBar {

    required override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
    }
    
    func currentSongChanged() {
        if let song = Session.sharedInstance.currentSong {
            self.tintColor = song.color
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
