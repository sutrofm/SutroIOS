//
//  FirstViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//

import UIKit
import Foundation

class ChatViewController: SLKTextViewController {
    var room :Room = UIApplication.rdioPartyApp.session.room

    var messages = Array<Message>()
    var backgroundImage = RPParallaxImageView()
    var firebaseRef :Firebase!
    
     required init(coder aDecoder: NSCoder) {
        super.init(tableViewStyle: UITableViewStyle.Plain)
        self.inverted = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.title = "Chat"
        
        firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/messages")

        self.tableView.registerNib(UINib(nibName: "ChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "UserMessage")
        self.tableView.registerNib(UINib(nibName: "ChatUserSongActionCell", bundle: nil), forCellReuseIdentifier: "ChatUserSongActionCell")
        self.tableView.registerNib(UINib(nibName: "ChatTrackChangedTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTrackChangedTableViewCell")
        
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.allowsSelection = false
        self.tableView.separatorColor = UIColor.clearColor()
        
        self.textInputbar.textView.autocorrectionType = UITextAutocorrectionType.Yes
        self.textInputbar.textView.autocapitalizationType = UITextAutocapitalizationType.Sentences
        self.textInputbar.textView.spellCheckingType = UITextSpellCheckingType.Yes

        self.backgroundImage.frame = self.view.frame
        self.backgroundImage.backgroundColor = UIColor.darkGrayColor() // Fallback color when an image isn't loaded for some reason
        self.view.insertSubview(self.backgroundImage, belowSubview: self.tableView)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBackground", name: "themeBackgroundChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateThemeColor", name: "themeColorChanged", object: nil)

        load()
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load() {
        
        self.firebaseRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil) {
                var type = snapshot.value.valueForKey("type") as! String
                var message = Message(fromSnapshot: snapshot)
                self.updateData(message) 
            }
        })
        
    }
    
    func updateData(message: Message) {
        self.messages.append(message)
        self.tableView.reloadData()
    }
        
    override func didPressRightButton(textInput: AnyObject!) {
        let formatter = NSDateFormatter()
        let date = NSDate()
        let text = textInputbar.textView.text
        
        let timestamp = formatter.stringFromDate(date)
        let message = ["fullName": UIApplication.rdioPartyApp.session.user.name, "message" : text, "type" : "User", "userKey" : UIApplication.rdioPartyApp.session.user.rdioId, "timestamp": timestamp]
        let postRef = self.firebaseRef.childByAutoId()
        postRef.setValue(message)
        super.didPressRightButton(textInput)
    }
    
    // TODO: Split this out somewhere else.  It makes our VC look ugly with so many cell types.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message = self.messages[self.messages.count - 1 - indexPath.row]
        
        if (message.type == MessageType.User) {
            let cell :ChatMessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("UserMessage", forIndexPath: indexPath) as! ChatMessageTableViewCell
            if let user :Person = self.room.getUser(message.userKey) {
                cell.userName?.text = user.name
                cell.userImage?.sd_setImageWithURL(NSURL(string: user.icon), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
                cell.transform = self.tableView.transform
            }
            cell.messageText?.text = message.text
            return cell
        } else if message.type == MessageType.UserAction {
            let user :Person = self.room.getUser(message.userKey)!
            let cell :ChatUserSongActionCell = tableView.dequeueReusableCellWithIdentifier("ChatUserSongActionCell", forIndexPath: indexPath) as! ChatUserSongActionCell
            cell.userImage?.sd_setImageWithURL(NSURL(string: user.icon), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
            cell.messageText?.text = String(stringInterpolation: user.name, " ", message.text)
            cell.transform = self.tableView.transform
            return cell
        } else if message.type == MessageType.NewTrack {
            let cell :ChatTrackChangedTableViewCell = tableView.dequeueReusableCellWithIdentifier("ChatTrackChangedTableViewCell", forIndexPath: indexPath) as! ChatTrackChangedTableViewCell
            cell.artistName.text = message.trackArtist
            cell.trackName.text = message.trackTitle
            cell.trackImage.sd_setImageWithURL(NSURL(string: message.trackImage))
            
            // If possible, add the user of the person who queued this song
            if let song = room.queue.getSongById(message.trackKey) {
                cell.backingView.backgroundColor = song.color.colorWithAlphaComponent(0.5)
                var userKey = song.userKey
                if let user = self.room.getUser(message.userKey) {
                    cell.userImage.sd_setImageWithURL(NSURL(string: user.icon))
                    cell.userImage.hidden = false
                } else {
                    cell.userImage.hidden = true
                }
            } else {
                cell.userImage.hidden = true
            }
            
            cell.transform = self.tableView.transform
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func updateBackground() {
        if (self.backgroundImage.image != nil) {
            UIView.transitionWithView(self.backgroundImage, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.backgroundImage.sd_setImageWithURL(UIApplication.rdioPartyApp.session.backgroundUrl)
                }, completion: nil)
        } else {
            self.backgroundImage.sd_setImageWithURL(UIApplication.rdioPartyApp.session.backgroundUrl)
        }
    }
    
    func updateThemeColor() {
        self.tabBarController?.tabBar.tintColor = UIApplication.rdioPartyApp.session.themeColor
        self.navigationController?.navigationBar.tintColor = UIApplication.rdioPartyApp.session.themeColor
    }


}

