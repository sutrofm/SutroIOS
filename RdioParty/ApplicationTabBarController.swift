//
//  ApplicationTabBarController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/9/15.
//

import UIKit

class ApplicationTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currentSongChanged() {
        if let song = UIApplication.rdioPartyApp.session.currentSong {
            self.tabBar.tintColor = song.color
            
            if let navBar :RPNavigationBar = self.navigationController?.navigationBar as? RPNavigationBar {
                navBar.tintColor = song.color
                navBar.secondaryLabelText = String(stringInterpolation: song.artistName, " - ", song.trackName)
            }
        }
    }
}
