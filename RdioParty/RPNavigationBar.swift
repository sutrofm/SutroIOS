//
//  RPNavigationBar.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//

import UIKit

class RPNavigationBar: UINavigationBar {

    let songLabel = UILabel()
    var secondaryLabel :UILabel!
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
        customizeNavbar()
        createSecondaryLabel()
    }
    
    func currentSongChanged() {
        if let song = Session.sharedInstance.currentSong {
            self.tintColor = song.color
            customizeNavbar()
            self.secondaryLabel.text = String(stringInterpolation: song.artistName, " - ", song.trackName)
        }
    }
    
    func customizeNavbar() {
        var veriticalOffset = CGFloat(0)
        if Session.sharedInstance.currentSong != nil {
            veriticalOffset = -6
            self.songLabel.hidden = false
        } else {
            self.songLabel.hidden = true
        }
        self.setTitleVerticalPositionAdjustment(veriticalOffset, forBarMetrics: UIBarMetrics.Default)
    }
    
    func createSecondaryLabel() {
        let labelHight = CGFloat(15)
        self.secondaryLabel = UILabel()
        self.secondaryLabel.textAlignment = NSTextAlignment.Center
        self.secondaryLabel.font = UIFont(name: self.secondaryLabel.font.familyName, size: 10)
        self.secondaryLabel.frame = CGRectMake(5, self.frame.size.height - labelHight - 2, self.frame.size.width - 10, labelHight)
        self.addSubview(self.secondaryLabel)
    }

}
