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

class FirstViewController: UIViewController, WebSocketDelegate {

    var socket: WebSocket

    required init(coder aDecoder: NSCoder) {
        
        var hostName = "s-dal5-nss-18.firebaseio.com"
        var url = NSURL(scheme: "wss", host: hostName, path: "/.ws?v=5&ns=rdioparty")
        self.socket = WebSocket(url:url!)

        super.init(coder: aDecoder)

        self.socket.delegate = self
        self.socket.connect()
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func websocketDidConnect(socket: WebSocket) {
        println("websocket is connected")

//        let b: Dictionary<AnyObject, AnyObject> = [
//            "p": "/valentine/player",
//            "h": ""
//        ]
//        
//        let d: Dictionary<AnyObject, AnyObject> = [
//            "r": 8,
//            "a": "l",
//            "b": b
//        ]
//
//        let jsonObject: Dictionary<AnyObject, AnyObject> = [
//            "t": "d",
//            "d": d
//        ] as Dictionary

        
        var jsonString = "{\"t\":\"d\",\"d\":{\"r\":8,\"a\":\"l\",\"b\":{\"p\":\"/valentine/player\",\"h\":\"\"}}}"
        self.socket.writeString(jsonString)
    }

    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        println("got some text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        println("got some data: \(data.length)")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        println("Websocket disconnected \(error)")
        

    }

}

