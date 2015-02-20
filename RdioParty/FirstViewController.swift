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

class FirstViewController: UIViewController, WebSocketDelegate, RdioDelegate, RDPlayerDelegate {

    var socket: WebSocket
    var rdio: Rdio
    var authenticated = false
    var currentSource :String!
    
    required init(coder aDecoder: NSCoder) {
        
        var hostName = "s-dal5-nss-18.firebaseio.com"
        var url = NSURL(scheme: "wss", host: hostName, path: "/.ws?v=5&ns=rdioparty")
        
        self.socket = WebSocket(url:url!)
        self.rdio = Rdio(consumerKey: "mqbnqec7reb8x6zv5sbs5bq4", andSecret: "NTu8GRBzr5", delegate: nil)
        super.init(coder: aDecoder)
        self.rdio.delegate = self
        self.socket.delegate = self
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (!authenticated) {
            authenticate()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func authenticate() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let accesstoken = defaults.stringForKey("rdioAccesstoken") {
            rdio.authorizeUsingAccessToken(accesstoken);
        } else {
            rdio.authorizeFromController(self)
        }
        
    }

    func websocketDidConnect(socket: WebSocket) {
        println("websocket is connected")
        
        var jsonString = "{\"t\":\"d\",\"d\":{\"r\":8,\"a\":\"l\",\"b\":{\"p\":\"/ohai/player\",\"h\":\"\"}}}"
        self.socket.writeString(jsonString)
    }

    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        println("got some text: \(text)")
        
        var json = JSON(data: text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        
        // Play Track
        if let trackKey = json["d"]["b"]["d"]["playingTrack"]["trackKey"].string {
//            if (trackKey != currentSource) {
                currentSource = trackKey
                playTrack(trackKey);
//            }
        }
        
        // Seek to position
        if let trackPosition = json["d"]["b"]["d"].double {
            positionTrack(trackPosition)
        }        
    }
    
    func positionTrack(position: Double) {
        if self.rdio.player.state.value == RDPlayerStatePlaying.value && self.rdio.player.position != position {
            self.rdio.player.seekToPosition(position)
        } else {
            self.rdio.player.play()
        }
    }
    
    func playTrack(trackKey: String ) {
        self.rdio.preparePlayerWithDelegate(self);

        if self.rdio.player.state.value == RDPlayerStatePlaying.value {
            self.rdio.player.stop()
        }
        self.rdio.player.playSource(trackKey)
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        println("got some data: \(data.length)")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        println("Websocket disconnected \(error)")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.socket.connect()
        })

    }

    // MARK: - RdioDelegate
    
    func rdioDidAuthorizeUser(user: [NSObject : AnyObject]!, withAccessToken accessToken: String!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(accessToken, forKey: "rdioAccessToken")
        self.authenticated = true;
        
        self.socket.connect()

    }
    
    func rdioAuthorizationFailed(error: NSError!) {
        println("Rdio authorization failed with error: \(error.localizedDescription)")
    }
    
    func rdioAuthorizationCancelled() {
        println("rdioAuthorizationCancelled")
    }
    
    func rdioDidLogout() {
    }
    
    // MARK: - RDPlayerDelegate
    
    // MARK: - RDPlayerDelegate
    
    func rdioIsPlayingElsewhere() -> Bool {
        // Let the Rdio framework tell the user
        return false
    }
    
    
    func rdioPlayerFailedDuringTrack(trackKey: String!, withError error: NSError!) -> Bool {
        println("Rdio failed to play track %@\n%@ \(trackKey, error)")
        return false
    }
    
    func rdioPlayerQueueDidChange() {
    }
    
    func rdioPlayerChangedFromState(oldState: RDPlayerState, toState newState: RDPlayerState) {
        
    }

}

