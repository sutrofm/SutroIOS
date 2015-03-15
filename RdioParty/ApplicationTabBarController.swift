//
//  ApplicationTabBarController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/9/15.
//

import UIKit

class ApplicationTabBarController: UITabBarController {

    var room :Room = UIApplication.rdioPartyApp.session.room
    var firebaseRef :Firebase!

    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
        firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(room.name)/messages")
    }

    override func viewDidAppear(animated: Bool) {
        setOnline()
    }
    
    override func viewWillDisappear(animated: Bool) {
        setOffline()
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
    
    func setOnline() {
        let firebaseOnline = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/people/")
        let postRef = firebaseOnline.childByAppendingPath(UIApplication.rdioPartyApp.session.user.rdioId + "/isOnline")
        // Auth is required
        self.firebaseRef.authWithCustomToken(UIApplication.rdioPartyApp.session.firebaseAuthToken, withCompletionBlock: { (error, authData) -> Void in
            let isOnline = true
            postRef.setValue(isOnline)
        })
    }
    
    func setOffline() {
        let firebaseOnline = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/people/")
        let postRef = firebaseOnline.childByAppendingPath(UIApplication.rdioPartyApp.session.user.rdioId + "/isOnline")
        // Auth is required
        self.firebaseRef.authWithCustomToken(UIApplication.rdioPartyApp.session.firebaseAuthToken, withCompletionBlock: { (error, authData) -> Void in
            let isOnline = false
            postRef.setValue(isOnline)
        })
    }
}
