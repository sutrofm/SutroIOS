//
//  SecondViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//

import UIKit

class QueueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MLPAutoCompleteTextFieldDelegate {

    var room :Room = Session.sharedInstance.room
    var queue = Session.sharedInstance.room.queue
    var playerBackingView = UIImageView()
    var backgroundImage = RPParallaxImageView()
    let searchDelegate = RdioSearchDelegate()
    var firebaseRef :Firebase!
    var partyPlayerManager = PartyPlayerManager()
    var playerHeaderCell :PlayerHeaderTableViewCell!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: MLPAutoCompleteTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.autoCompleteDataSource = self.searchDelegate
        self.searchBar.autoCompleteDelegate = self
        self.backgroundImage.frame = self.view.frame
        self.view.insertSubview(self.backgroundImage, belowSubview: self.tableView)

        self.playerBackingView.frame = CGRectMake(0, 95, self.view.frame.size.width, 250)
        self.playerBackingView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.insertSubview(self.playerBackingView, belowSubview: self.tableView)
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.playerBackingView.frame.size.height + 90, 0, 50, 0) //TODO: Don't hard code the table inset
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.allowsSelection = false
        
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
        
        currentSongChanged()
        updateQueueCount()
        
        firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/queue")
        self.partyPlayerManager.firebaseRef = self.firebaseRef
        Session.sharedInstance.playerManager.rdio.player.addPeriodicTimeObserverForInterval(CMTimeMake(1, 100), queue: dispatch_get_main_queue(),
            usingBlock: { (time: CMTime) -> Void in
                let seconds:Float64 = CMTimeGetSeconds(time)
                self.updateTrackProgress(Session.sharedInstance.playerManager.rdio.player.position)
           })
        
        // Auth is required to add to the queue
        self.firebaseRef.authWithCustomToken(Session.sharedInstance.firebaseAuthToken, withCompletionBlock: { (error, authData) -> Void in
            println(authData)
            println(error)
        })
        
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load() {

        // Track added
        firebaseRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil) {
                var song = Song(fromSnapshot: snapshot)
                Session.sharedInstance.playerManager.updateSongWithDetails(song, completionClosure: { () in
                    self.queue.add(song)
                    self.tableView.reloadData()
                });
                self.tableView.reloadData()
                self.updateQueueCount()
            }
        })
        
        // Track removed
        firebaseRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let trackKey = snapshot.value.valueForKey("trackKey") as! String
            self.queue.removeSongById(trackKey)
            self.updateQueueCount()
        })
        
        // Queue changed
        firebaseRef.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.queue.sort()
            self.tableView.reloadData()
            self.updateQueueCount()
        })
    }
    
    func currentSongChanged() {
        if let song = Session.sharedInstance.currentSong {
        
            if self.playerHeaderCell != nil {
                self.playerHeaderCell.setDuration(song.duration)
                self.playerHeaderCell.setProgress(0)
                self.playerHeaderCell.progressMeter.tintColor = song.color
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
        self.playerHeaderCell.setDuration(Session.sharedInstance.currentSong.duration)
        self.playerHeaderCell.setProgress(Float(seconds))
    }
    
    func addTrackToQueue(trackKey :String) {
        var track = ["trackKey": trackKey, "userKey" : Session.sharedInstance.user.rdioId, "votes" : [Session.sharedInstance.user.rdioId : "like"]]
        var postRef = self.firebaseRef.childByAutoId()
        postRef.setValue(track)
    }
    
    func updateQueueCount() {
        self.tabBarItem.badgeValue = String(self.queue.count())
    }
    
    func playPauseButtonPressed(sender :UIButton!) {
        if (Session.sharedInstance.playerManager.rdio.player.state.value == RDPlayerStatePlaying.value) {
            Session.sharedInstance.playerManager.rdio.player.stop()
        } else {
            Session.sharedInstance.playerManager.rdio.player.play()
        }
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queue.count() + 1 // At least one cell: Player controls
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var currentSong = Session.sharedInstance.currentSong
        
        // Player controls
        if indexPath.row == 0 {
            self.playerHeaderCell = tableView.dequeueReusableCellWithIdentifier("PlayerHeaderTableViewCell") as! PlayerHeaderTableViewCell
            
            if currentSong != nil {
                self.playerHeaderCell.trackNameLabel.text = currentSong.trackName
                self.playerHeaderCell.artistNameLabel.text = currentSong.artistName
                self.playerHeaderCell.progressMeter.tintColor = currentSong.color
                self.playerHeaderCell.progressMeter.progress = 0
                updateTrackProgress(0)
                
                // Person who added the song
                if currentSong.userKey != nil { // I thought with Swift 1.2 you could combine conditionals and unwrapping?
                    if let userAdded = self.room.getUser(currentSong.userKey) {
                        self.playerHeaderCell.addedByLabel.text = "Added by " + userAdded.name
                    }
                } else {
                    self.playerHeaderCell.addedByLabel.text = ""
                }
            }
            return self.playerHeaderCell
        }
        
        // Queue item
        let song = self.queue.songAtIndex(indexPath.row-1)

        var cell = tableView.dequeueReusableCellWithIdentifier("QueueItemCell") as! QueueItemCellTableViewCell
        
//        cell.voteUpButton.titleLabel!.text = String(song.upVotes())
//        cell.voteDownButton.titleLabel!.text = String(song.downVotes())
        
        cell.trackArtist.text = song.artistName
        cell.trackName.text = song.trackName

        cell.trackLength.text = Utils.secondsToHoursMinutesSecondsString(song.duration)
        
        // Person who added the song
        if let userAddedName = self.room.getUser(song.userKey)?.name {
            cell.userAddedLabel.text = "Added by " + userAddedName
        } else {
            cell.userAddedLabel.text = ""
        }
        
        cell.trackImage.sd_setImageWithURL(NSURL(string: song.icon))
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = song.color.colorWithAlphaComponent(0.3)
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = abs(scrollView.contentOffset.y)
        var alpha :CGFloat = 1.0
        var target = self.playerBackingView.frame.size.height + 85 //TODO: Magic number alert.  This is the height of the first header row.
        if (offset < target) {
            var pct = offset / target
            alpha = CGFloat(pct - 0.5) // Speed up the fade out
        }
        
        // Slightly animate it
        UIView.transitionWithView(self.playerBackingView, duration: 0.1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.playerBackingView.alpha = alpha
            }, completion: nil)
    }
    
    // MARK: - Auto complete sarch
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, didSelectAutoCompleteString selectedString: String!, withAutoCompleteObject selectedObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) {
        if let selectedObject = selectedObject as? AutoCompleteObject {
            addTrackToQueue(selectedObject.trackKey)
        }

        textField.text = ""
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, shouldConfigureCell cell: UITableViewCell!, withAutoCompleteString autocompleteString: String!, withAttributedString boldedString: NSAttributedString!, forAutoCompleteObject autocompleteObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        var rpAutoCompleteObject = autocompleteObject as! AutoCompleteObject
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imageView?.sd_setImageWithURL(NSURL(string: rpAutoCompleteObject.image), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
        return true
    }

}

