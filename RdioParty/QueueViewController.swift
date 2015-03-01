//
//  SecondViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, RdioDelegate {

    var room :Room = Session.sharedInstance.room
    var queue = Session.sharedInstance.room.queue
    var playerView = PlayerView.instanceFromNib()
    
    var backgroundImage = UIImageView()
    
    var rdio = Rdio(consumerKey: "mqbnqec7reb8x6zv5sbs5bq4", andSecret: "NTu8GRBzr5", delegate: nil)

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rdio.delegate = self

        self.backgroundImage.frame = self.view.frame
        self.view.insertSubview(self.backgroundImage, belowSubview: self.tableView)

        self.playerView.frame = CGRectMake(0, 60, self.view.frame.size.width, 250)
        self.view.insertSubview(self.playerView, belowSubview: self.tableView)
        
        self.tableView.contentInset = UIEdgeInsetsMake(260, 0, 50, 0)
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.allowsSelection = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBackground", name: "themeBackgroundChanged", object: nil)

        updateBackground()
        
        load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load() {
        
        var ref = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/queue")

        // Track added
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil) {
                var song = Song(fromSnapshot: snapshot)
                self.updateSongWithDetails(song)
                self.tableView.reloadData()
            }
        })
        
        // Track removed
        ref.observeEventType(.ChildRemoved, withBlock: { snapshot in
            let trackKey = snapshot.value.valueForKey("trackKey") as! String
            self.queue.removeSongById(trackKey)
        })
        
        // Queue changed
        ref.observeEventType(.ChildRemoved, withBlock: { snapshot in
            self.queue.sort()
            self.tableView.reloadData()
        })
    }
    
    func updateBackground() {
        UIView.transitionWithView(self.backgroundImage, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.backgroundImage.sd_setImageWithURL(Session.sharedInstance.backgroundUrl)
        }, completion: nil)
    }
    
    // MARK: - Track Details
    func updateSongWithDetails(song: Song) {
        var parameters:Dictionary<NSObject, AnyObject!> = ["keys": song.trackKey, "extras": "-*,name,artist,dominantColor,duration,bigIcon,icon,playerBackgroundUrl"]

        self.rdio.callAPIMethod("get",
            withParameters: parameters,
            success: { (result) -> Void in

                let track: AnyObject? = result[song.trackKey]
                song.updateWithApiData(track! as! NSDictionary)
                self.queue.add(song)
                self.tableView.reloadData()
                
            }) { (error) -> Void in
                // Error
        }
    }
    
    // MARK: - Table View
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queue.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let song = self.queue.songAtIndex(indexPath.row)
        var cell = tableView.dequeueReusableCellWithIdentifier("QueueItemCell") as! QueueItemCellTableViewCell
        cell.upVoteLabel.text = String(song.upVoteKeys.count)
        cell.downVoteLabel.text = String(song.downVoteKeys.count)
        cell.trackArtist.text = song.artistName
        cell.trackName.text = song.trackName
        cell.trackImage.sd_setImageWithURL(NSURL(string: song.icon))
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = song.color.colorWithAlphaComponent(0.3)
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
    }


}

