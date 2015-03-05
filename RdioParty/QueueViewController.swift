//
//  SecondViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MLPAutoCompleteTextFieldDelegate {

    var room :Room = Session.sharedInstance.room
    var queue = Session.sharedInstance.room.queue
    var playerView :PlayerView = PlayerView.instanceFromNib()
    var backgroundImage = UIImageView()
    let searchDelegate = RdioSearchDelegate()
    var firebaseRef :Firebase!
    var partyPlayerManager = PartyPlayerManager()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: MLPAutoCompleteTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.autoCompleteDataSource = self.searchDelegate
        self.searchBar.autoCompleteDelegate = self
        self.backgroundImage.frame = self.view.frame
        self.view.insertSubview(self.backgroundImage, belowSubview: self.tableView)

        self.playerView.frame = CGRectMake(0, 95, self.view.frame.size.width, 250)
        self.view.insertSubview(self.playerView, belowSubview: self.tableView)

        self.tableView.contentInset = UIEdgeInsetsMake(270, 0, 50, 0)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.allowsSelection = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "currentSongChanged", name: "currentSongChanged", object: nil)
        
        self.playerView.playPauseButton.addTarget(self, action: "playPauseButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)

        currentSongChanged()
        updateQueueCount()
        
        firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/queue")
        self.partyPlayerManager.firebaseRef = self.firebaseRef
        
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
        updateBackground()
        
        if let song = Session.sharedInstance.currentSong {
            self.playerView.image.sd_setImageWithURL(NSURL(string: song.bigIcon))
            self.playerView.artistName.text = song.artistName
            self.playerView.trackName.text = song.trackName
            
            UIView.transitionWithView(self.backgroundImage, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.backgroundImage.sd_setImageWithURL(song.backgroundImage)
                }, completion: nil)
        }
    }
    
    func updateBackground() {
        UIView.transitionWithView(self.backgroundImage, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.backgroundImage.sd_setImageWithURL(Session.sharedInstance.backgroundUrl)
        }, completion: nil)
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
        return self.queue.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let song = self.queue.songAtIndex(indexPath.row)
        var cell = tableView.dequeueReusableCellWithIdentifier("QueueItemCell") as! QueueItemCellTableViewCell
        
        cell.voteUpButton.titleLabel!.text = String(song.upVoteKeys.count)
        cell.voteDownButton.titleLabel!.text = String(song.downVoteKeys.count)
        
        cell.trackArtist.text = song.artistName
        cell.trackName.text = song.trackName
        cell.trackImage.sd_setImageWithURL(NSURL(string: song.icon))
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = song.color.colorWithAlphaComponent(0.3)
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = abs(scrollView.contentOffset.y)
        var alpha :CGFloat = 1.0
        
        if (offset < 265) {
            var pct = offset / 270
            alpha = CGFloat(pct - 0.3) // Speed up the fade out
        }
        self.playerView.alpha = alpha
    }
    
    // MARK: - Auto complete sarch
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, didSelectAutoCompleteString selectedString: String!, withAutoCompleteObject selectedObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) {
        println(selectedObject)
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, shouldConfigureCell cell: UITableViewCell!, withAutoCompleteString autocompleteString: String!, withAttributedString boldedString: NSAttributedString!, forAutoCompleteObject autocompleteObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        var rpAutoCompleteObject = autocompleteObject as! AutoCompleteObject
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        cell.imageView?.sd_setImageWithURL(NSURL(string: rpAutoCompleteObject.image), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
        return true
    }

}

