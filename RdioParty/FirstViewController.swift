//
//  FirstViewController.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/19/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import Starscream
import Foundation
import SwiftyJSON
import SlackTextViewController

class FirstViewController: SLKTextViewController {

//    var socket: WebSocket
//    var rdio: Rdio
//    var authenticated = false
//    var currentSource :String!
//    
//    var room = "test1234"
    
     required init(coder aDecoder: NSCoder) {
        
//
//        self.rdio = Rdio(consumerKey: "mqbnqec7reb8x6zv5sbs5bq4", andSecret: "NTu8GRBzr5", delegate: nil)
        super.init(tableViewStyle: UITableViewStyle.Plain)
        self.inverted = true
        //super.init(coder: aDecoder)
//        self.rdio.delegate = self

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ConnectionManager.sharedInstance.room.name
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "messagesUpdated:", name: "rdioparty.messagesListChanged", object: nil)
                
        // Do any additional setup after loading the view, typically from a nib.
        ConnectionManager.sharedInstance.getMessagesInRoom(ConnectionManager.sharedInstance.room)
    
    }
    
    override func viewDidAppear(animated: Bool) {
        if (ConnectionManager.sharedInstance.room == nil) {
            let roomvc = RoomsViewController(nibName: "RoomsViewController", bundle: nil)
            self.presentViewController(roomvc, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func messagesUpdated(notification: NSNotification) {
        self.tableView.reloadData()
//        var messageObject: AnyObject? = notification.object as! Message
//        if let messageObject = messageObject as? Message {
//        }


//        self.refreshMessages()
    }
    
    override func didCommitTextEditing(sender: AnyObject!) {
        if let textInput = sender as? UITextView {
            
        }
        super.didCommitTextEditing(sender)
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var message = ConnectionManager.sharedInstance.room.messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = message.text
        cell.transform = self.tableView.transform

        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConnectionManager.sharedInstance.room.messages.count
    }
    
    

//    func authenticate() {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        if let accesstoken = defaults.stringForKey("rdioAccesstoken") {
//            rdio.authorizeUsingAccessToken(accesstoken);
//        } else {
//            rdio.authorizeFromController(self)
//        }
//        
//    }
//
//    func websocketDidConnect(socket: WebSocket) {
//        println("websocket is connected")
//        getPeopleInRoom(self.room)
//    }
//
//    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
//        println("got some text: \(text)")
//        
//        var json = JSON(data: text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
//        var content = json["d"]["b"]["d"]
//        
//        // Play Track
//        if let trackKey = content["playingTrack"]["trackKey"].string {
////            if (trackKey != currentSource) {
//                currentSource = trackKey
//                playTrack(trackKey);
////            }
//        }
//        
//        // Seek to position
//        if let trackPosition = content.double {
//            positionTrack(trackPosition)
//        }
//    }
//    
//    func positionTrack(position: Double) {
//        if self.rdio.player.state.value == RDPlayerStatePlaying.value && abs(position - self.rdio.player.position) > 2 {
//            self.rdio.player.seekToPosition(position)
//        }
//    }
//    
//    func playTrack(trackKey: String ) {
//        
//        if (self.rdio.player.state.value == RDPlayerStatePlaying.value ) {
//            self.rdio.player.resetQueue()
//        }
//        
//        self.rdio.player.play(trackKey)
//        getTrack(trackKey)
//    }
//    
//    func getTrack(trackKey: String) {
//        let parameters:Dictionary<NSObject, AnyObject!> = ["keys": trackKey, "extras": "-*, name, album, albumArtist, duration, gridIcon"]
//        self.rdio.callAPIMethod("get", withParameters: parameters, success: { (result) -> Void in
//            // Success
//            println(result)
//        }) { (error) -> Void in
//            // Error
//        }
//    }
//    
//    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
//        println("got some data: \(data.length)")
//    }
//    
//    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
//        println("Websocket disconnected \(error)")
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            self.socket.connect()
//        })
//
//    }
//    
//    func rdioRequest(request: RDAPIRequest!, didLoadData data: AnyObject!) {
//        println(data)
//    }
//    
//    func rdioRequest(request: RDAPIRequest!, didFailWithError error: NSError!) {
//        println(error)
//    }
//
//    // MARK: - RdioDelegate
//    
//    func rdioDidAuthorizeUser(user: [NSObject : AnyObject]!, withAccessToken accessToken: String!) {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(accessToken, forKey: "rdioAccessToken")
//        self.authenticated = true;
//        
//        self.socket.connect()
//
//    }
//    
//    func rdioAuthorizationFailed(error: NSError!) {
//        println("Rdio authorization failed with error: \(error.localizedDescription)")
//    }
//    
//    func rdioAuthorizationCancelled() {
//        println("rdioAuthorizationCancelled")
//    }
//    
//    func rdioDidLogout() {
//    }
//    
//    // MARK: - RDPlayerDelegate
//    
//    // MARK: - RDPlayerDelegate
//    
//    func rdioIsPlayingElsewhere() -> Bool {
//        // Let the Rdio framework tell the user
//        return false
//    }
//    
//    
//    func rdioPlayerFailedDuringTrack(trackKey: String!, withError error: NSError!) -> Bool {
//        println("Rdio failed to play track %@\n%@ \(trackKey, error)")
//        return false
//    }
//    
//    func rdioPlayerQueueDidChange() {
//    }
//    
//    func rdioPlayerChangedFromState(oldState: RDPlayerState, toState newState: RDPlayerState) {
//        
//    }
//    
//    func getPeopleInRoom(roomname: String) {
//        var json = "{\"t\":\"d\",\"d\":{\"r\":6,\"a\":\"l\",\"b\":{\"p\":\"/\(roomname)/people\",\"h\":\"\"}}}"
//        self.socket.writeString(json)
//        
//        var msgsJson = "{\"t\":\"d\",\"d\":{\"r\":6,\"a\":\"l\",\"b\":{\"p\":\"/test1234/messages\",\"h\":\"\"}}}"
//        self.socket.writeString(msgsJson)
//        
//        println(json)
//    }
//
//    func getPlayerInRoom(roomname: String) {
//        var jsonString = "{\"t\":\"d\",\"d\":{\"r\":8,\"a\":\"l\",\"b\":{\"p\":\"/\(roomname)/player\",\"h\":\"\"}}}"
//        self.socket.writeString(jsonString)
//    }
}

