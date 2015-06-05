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
    var backgroundImage = RPParallaxImageView(image: nil)
    var firebaseRef :Firebase!
    let rdio = UIApplication.rdioPartyApp.playerManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.inverted = true
        
        firebaseRef = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/messages")

        tableView.registerClass(ChatMessageTableViewCell.self, forCellReuseIdentifier: "UserMessage")
        tableView.registerNib(UINib(nibName: "ChatUserSongActionCell", bundle: nil), forCellReuseIdentifier: "ChatUserSongActionCell")
        tableView.registerNib(UINib(nibName: "ChatTrackChangedTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTrackChangedTableViewCell")
        
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.allowsSelection = false
        tableView.separatorColor = UIColor.clearColor()
        
        textInputbar.textView.autocorrectionType = UITextAutocorrectionType.Yes
        textInputbar.textView.autocapitalizationType = UITextAutocapitalizationType.Sentences
        textInputbar.textView.spellCheckingType = UITextSpellCheckingType.Yes

        backgroundImage.frame = self.view.frame
        backgroundImage.backgroundColor = UIColor.darkGrayColor() // Fallback color when an image isn't loaded for some reason
        view.insertSubview(self.backgroundImage, belowSubview: self.tableView)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateBackground", name: "themeBackgroundChanged", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateThemeColor", name: "themeColorChanged", object: nil)

        load()
        setTitle()
    }
    
    override func viewWillAppear(animated: Bool) {
        setTitle()
    }
    
    func setTitle() {
        if let navbar = UIApplication.rdioPartyApp.navigationBar {
            navbar.setTitle("Chat")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load() {

        firebaseRef.observeEventType(.ChildAdded, withBlock: { snapshot in
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
        let text = textInputbar.textView.text
        let message = ["fullName": UIApplication.rdioPartyApp.session.user.name, "message" : text, "type" : "User", "userKey" : UIApplication.rdioPartyApp.session.user.rdioId, "timestamp" : NSDate().formatted]
        let postRef = self.firebaseRef.childByAutoId()
        postRef.setValue(message)
        super.didPressRightButton(textInput)
    }
    
    // TODO: Split this out somewhere else.  It makes our VC look ugly with so many cell types.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message = self.messages[self.messages.count - 1 - indexPath.row]
        
        if (message.type == MessageType.User) {
            let cell :ChatMessageTableViewCell = tableView.dequeueReusableCellWithIdentifier("UserMessage", forIndexPath: indexPath) as! ChatMessageTableViewCell
            rdio.getPersonWithDetails(message.userKey, completionClosure: { (person) -> () in
                cell.userName.text = person.name
                cell.userImage.sd_setImageWithURL(NSURL(string: person.icon), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
            })
            
            cell.transform = self.tableView.transform
            cell.messageText.text = message.text
            
            cell.setNeedsUpdateConstraints()
            cell.setNeedsLayout()
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

            populateTrackPlayingCellWithTrack(cell, message: message)
            populateTrackPlayingCellWithUser(cell, message: message)
            
            cell.transform = self.tableView.transform
            return cell
        }
        return UITableViewCell()
    }
    
    
    func populateTrackPlayingCellWithUser(cell :ChatTrackChangedTableViewCell, message: Message) {
        // Person who added the song from queue history
        // We may not have this information if you just joined the room.
        if let song = room.queue.getSongById(message.trackKey), userKey = song.userKey {
            if let user = room.getUser(userKey) {
                cell.userImage.sd_setImageWithURL(NSURL(string: user.icon))
                cell.userImage.hidden = false
            } else {
                cell.userImage.hidden = true
            }
        } else {
            cell.userImage.hidden = true
        }
    }
    
    func populateTrackPlayingCellWithTrack(cell :ChatTrackChangedTableViewCell, message: Message) {

        // Get song details currently just to get the color
        if let trackKey = message.trackKey {
            rdio.getSongWithDetails(trackKey, completionClosure: { (updatedSong, cached) -> () in
                let newColor = updatedSong.color.colorWithAlphaComponent(0.3)
                if cell.backingView.backgroundColor != newColor {
                    let animationDuration = cached ? 0.0 : 0.5
                    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
                        cell.backingView.layer.backgroundColor = newColor.CGColor
                    })
                    
                }
            })
        }
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

