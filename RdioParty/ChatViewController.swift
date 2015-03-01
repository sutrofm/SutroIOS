//
//  FirstViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import Foundation

class ChatViewController: SLKTextViewController {
    var room :Room = Session.sharedInstance.room

    var messages = Array<Message>()
    var backgroundImage = UIImageView()
    
     required init(coder aDecoder: NSCoder) {
        super.init(tableViewStyle: UITableViewStyle.Plain)
        self.inverted = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.room.name
        
        self.tableView.registerNib(UINib(nibName: "ChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "UserMessage")
        self.tableView.estimatedRowHeight = 75.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.allowsSelection = false

        self.backgroundImage.frame = self.view.frame
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
        
        var ref = Firebase(url:"https://rdioparty.firebaseio.com/\(self.room.name)/messages")
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            if (snapshot.key != nil) {
                var type = snapshot.value.valueForKey("type") as! String
                if (type == "User") {
                    var message = Message(fromSnapshot: snapshot)
                    self.updateData(message)
                } else if (type == "User") {
                    
                }
            }
        })
        
    }
    
    func updateData(message: Message) {
        self.messages.append(message)
        self.tableView.reloadData()
    }
    
    override func didCommitTextEditing(sender: AnyObject!) {
        if let textInput = sender as? UITextView {
            
        }
        super.didCommitTextEditing(sender)
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message = self.messages[self.messages.count - 1 - indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserMessage", forIndexPath: indexPath) as! ChatMessageTableViewCell        
        let user :Person = self.room.getUser(message.userKey)!
        
        cell.messageText?.text = message.text
        cell.userName?.text = user.name
        cell.userImage?.sd_setImageWithURL(NSURL(string: user.icon), placeholderImage: UIImage(named: "rdioPartyLogo.png"))
        cell.transform = self.tableView.transform

        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.4)

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func updateBackground() {
        if (self.backgroundImage.image != nil) {
            UIView.transitionWithView(self.backgroundImage, duration: 2.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                self.backgroundImage.sd_setImageWithURL(Session.sharedInstance.backgroundUrl)
                }, completion: nil)
        } else {
            self.backgroundImage.sd_setImageWithURL(Session.sharedInstance.backgroundUrl)
        }
    }
    
    func updateThemeColor() {
        self.tabBarController?.tabBar.tintColor = Session.sharedInstance.themeColor
        self.navigationController?.navigationBar.tintColor = Session.sharedInstance.themeColor
    }


}

