//
//  SecondViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//

import UIKit

class QueueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MLPAutoCompleteTextFieldDelegate {

    var room :Room = UIApplication.rdioPartyApp.session.room
    var queue = UIApplication.rdioPartyApp.session.room.queue
    var playerBackingView = UIImageView()
    var playerBackingUserImage = UIImageView()
    var backgroundImage = RPParallaxImageView(image: nil)
    let searchDelegate = RdioSearchDelegate()
    var firebaseRef :Firebase!
    var partyPlayerManager : PartyPlayerManager!
    var playerHeaderCell :PlayerHeaderTableViewCell!
    let player = UIApplication.rdioPartyApp.playerManager.rdio.player
    let rdio = UIApplication.rdioPartyApp.playerManager
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: MLPAutoCompleteTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/queue")
        self.partyPlayerManager = PartyPlayerManager(firebaseRef: self.firebaseRef)
        
        self.searchBar.autoCompleteDataSource = self.searchDelegate
        self.searchBar.autoCompleteDelegate = self
        self.backgroundImage.frame = self.view.frame
        self.view.insertSubview(self.backgroundImage, belowSubview: self.tableView)

        self.playerBackingView.frame = CGRectMake(0, 100, self.view.frame.size.width, 250)
        self.playerBackingView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.insertSubview(self.playerBackingView, belowSubview: self.tableView)
        
        playerBackingUserImage.frame = CGRectMake(10, 20, 40, 40)
        playerBackingUserImage.clipsToBounds = true
        playerBackingUserImage.layer.cornerRadius = playerBackingUserImage.frame.size.width / 2
        playerBackingView.addSubview(playerBackingUserImage)
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.playerBackingView.frame.size.height, 0, 50, 0) //TODO: Don't hard code the table inset
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.allowsSelection = false
        
        self.tableView.estimatedRowHeight = 100.0

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
        
        currentSongChanged()
        updateQueueCount()
        
        partyPlayerManager.firebase = self.firebaseRef
        UIApplication.rdioPartyApp.playerManager.rdio.player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue(),
            usingBlock: { (time: CMTime) -> Void in
                let seconds:Float64 = CMTimeGetSeconds(time)
                self.updateTrackProgress(self.player.position)
       })
        
        UIApplication.rdioPartyApp.playerManager.rdio.player.addPeriodicLevelObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue(),
            usingBlock: { (left: Float32, right: Float32 ) -> Void in
        })
        
        // Auth is required to add to the queue
        self.firebaseRef.authWithCustomToken(UIApplication.rdioPartyApp.session.firebaseAuthToken, withCompletionBlock: { (error, authData) -> Void in
            println(authData)
            println(error)
        })
        
        load()
        setTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        setTitle()
    }
    
    func setTitle() {
        if let navbar = UIApplication.rdioPartyApp.navigationBar {
            navbar.setTitle("Queue")
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load() {

        // Track added
        firebaseRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil && snapshot.value.valueForKey("trackKey") != nil) {
                var song = Song(fromSnapshot: snapshot)
                UIApplication.rdioPartyApp.playerManager.getSongWithDetails(song.trackKey, completionClosure: { (newSong, cached) in
                    self.queue.add(newSong)
                    self.tableView.reloadData()
                });
                self.tableView.reloadData()
                self.updateQueueCount()
            }
        })
        
        // Track removed
        firebaseRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            if let trackKey = snapshot.value.valueForKey("trackKey") as? String {
                self.queue.removeSongById(trackKey)
                self.updateQueueCount()
            }
        })
        
        // Queue changed
        firebaseRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.queue.sort()
            self.tableView.reloadData()
            self.updateQueueCount()
        })
    }
    
    func currentSongChanged() {
        if let song = UIApplication.rdioPartyApp.session.currentSong {
        
            if self.playerHeaderCell != nil {
                self.playerHeaderCell.setDuration(song.duration)
                self.playerHeaderCell.setProgress(0)
                self.playerHeaderCell.currentSongColor = song.color
            }
            
            var fadeDuration = 2.0
            if (self.backgroundImage.image == nil || self.playerBackingView.image == nil) {
                fadeDuration = 0
            }
            UIView.transitionWithView(self.playerBackingView, duration: fadeDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.playerBackingView.sd_setImageWithURL(NSURL(string: song.bigIcon))
                }, completion: nil)
            UIView.transitionWithView(self.backgroundImage, duration: fadeDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.backgroundImage.sd_setImageWithURL(song.backgroundImage)
                }, completion: nil)

            self.tableView.reloadData()
        }
    }
    
    func updateTrackProgress(seconds :Float64) {
        self.playerHeaderCell.setDuration(UIApplication.rdioPartyApp.session.currentSong.duration)
        self.playerHeaderCell.setProgress(Float(seconds))
    }
    
    func updateQueueCount() {
//        self.tabBarItem.badgeValue = String(self.queue.count())
    }
    
    func playPauseButtonPressed(sender :UIButton!) {
        let isPlaying = UIApplication.rdioPartyApp.playerManager.rdio.player.state.value == RDPlayerStatePlaying.value
        if (isPlaying) {
            player.stop()
        } else {
            player.play()
        }
        self.playerHeaderCell.playing = isPlaying
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If there's no queue and no current song then the table shouldn't display a player
        if (queue.count() == 0 && UIApplication.rdioPartyApp.session.currentSong == nil) {
            return 0
        }
        
        return self.queue.count() + 1 // At least one cell: Player controls
    }

    // No reason to use autosized cells for this table.  There are only two static heights.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else {
            return 100
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var currentSong = UIApplication.rdioPartyApp.session.currentSong
        
        // Player controls
        if indexPath.row == 0 {
            self.playerHeaderCell = tableView.dequeueReusableCellWithIdentifier("PlayerHeaderTableViewCell") as! PlayerHeaderTableViewCell
            
            if currentSong != nil {
                self.playerHeaderCell.trackNameLabel.text = currentSong.trackName
                self.playerHeaderCell.artistNameLabel.text = currentSong.artistName
                self.playerHeaderCell.currentSongColor = currentSong.color
                self.playerHeaderCell.progressMeter.progress = 0
                self.playerHeaderCell.playing = player.state.value == RDPlayerStatePlaying.value
                updateTrackProgress(0)
                
                self.playerHeaderCell.downVoteButton.addTarget(self, action: "downVotePressed", forControlEvents: UIControlEvents.TouchUpInside)
                self.playerHeaderCell.favoriteButton.addTarget(self, action: "favoriteButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                self.playerHeaderCell.playPauseButton.addTarget(self, action: "playPausePressed", forControlEvents: UIControlEvents.TouchUpInside)
                
                // Person who added the song
                rdio.getPersonWithDetails(currentSong.userKey, completionClosure: { (userAdded) -> () in
                    self.playerHeaderCell.addedByLabel.text = "Added by " + userAdded.name
                    self.playerBackingUserImage.sd_setImageWithURL(NSURL(string: userAdded.icon))
                })

            }
            // Hide the player if we're in a weird case where we have a queue
            // but nothing is playing.  This would be a bug on the server.
            if currentSong == nil {
                playerHeaderCell.hidden = true
            } else {
                playerHeaderCell.hidden = false
            }
            return self.playerHeaderCell
        }
        
        // Queue item
        let song = self.queue.songAtIndex(indexPath.row-1)

        var cell = tableView.dequeueReusableCellWithIdentifier("QueueItemCell") as! QueueItemCellTableViewCell
        
        cell.voteUpButton.titleLabel!.text = String(song.upVotes())
        cell.voteUpButton.tag = indexPath.row - 1
        cell.voteUpButton.addTarget(self, action: "upVotePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.voteDownButton.titleLabel!.text = String(song.downVotes())
        cell.voteDownButton.tag = indexPath.row - 1
        cell.voteDownButton.addTarget(self, action: "downVotePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.trackArtist.text = song.artistName
        cell.trackName.text = song.trackName

        cell.trackLength.text = Utils.secondsToHoursMinutesSecondsString(song.duration)
        
        // Person who added the song
        if let userKey = song.userKey {
            if let userAddedName = self.room.getUser(userKey)?.name {
                cell.userAddedLabel.text = "Added by " + userAddedName
            } else {
                cell.userAddedLabel.text = ""
            }
        }
        
        cell.trackImage.sd_setImageWithURL(NSURL(string: song.icon))
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = song.color.colorWithAlphaComponent(0.3)
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = abs(scrollView.contentOffset.y)
        var alpha :CGFloat = 1.0
        var target = self.playerBackingView.frame.size.height
        if (offset < target) {
            var pct = offset / target
            alpha = max(0.0, CGFloat(pct - 0.5)) // Speed up the fade out
        }
        
        // Slightly animate it
        UIView.transitionWithView(self.playerBackingView, duration: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.playerBackingView.alpha = alpha
            if (self.playerHeaderCell != nil) {
                self.playerHeaderCell.playPauseButton.alpha = alpha
                self.playerHeaderCell.favoriteButton.alpha = alpha
                self.playerHeaderCell.downVoteButton.alpha = alpha
            }
            }, completion: nil)
    }
    
    // MARK: - Auto complete sarch
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, didSelectAutoCompleteString selectedString: String!, withAutoCompleteObject selectedObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) {
        if let selectedObject = selectedObject as? AutoCompleteObject {
            partyPlayerManager.addTrackToQueue(selectedObject.trackKey)
            textField.resignFirstResponder()
        }

        textField.text = ""
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, shouldConfigureCell cell: UITableViewCell!, withAutoCompleteString autocompleteString: String!, withAttributedString boldedString: NSAttributedString!, forAutoCompleteObject autocompleteObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        var rpAutoCompleteObject = autocompleteObject as! AutoCompleteObject
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imageView?.sd_setImageWithURL(NSURL(string: rpAutoCompleteObject.image), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
        return true
    }
    
    func playPausePressed() {
        player.togglePause()
        playerHeaderCell.playing = player.state.value == RDPlayerStatePlaying.value
    }
    
    func downVotePressed(sender: UIButton!) {
        let song = queue.songAtIndex(sender.tag)
        partyPlayerManager.voteDownSong(song)
    }
    
    func favoriteButtonPressed(sender: UIButton!) {
        let song = queue.songAtIndex(sender.tag)
        
        if !song.favorite {
            partyPlayerManager.favoriteSong(song) { (success) -> () in
                var favoriteConfirmation :String!
                if (success) {
                    favoriteConfirmation = "Favorited."
                    song.favorite = true
                    self.playerHeaderCell.favoriteButton.tintColor = UIColor.redColor()
                } else {
                    favoriteConfirmation = "There was a problem favoriting this song."
                }
                
                let hud = RPHud(style: JGProgressHUDStyle.Dark)
                hud.textLabel.text = favoriteConfirmation
                hud.showInView(self.view, animated: false)
                hud.dismissAfterDelay(2, animated: true)
            }
        }
    }

}

