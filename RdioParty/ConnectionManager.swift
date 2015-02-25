//
//  ConnectionManager.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/21/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit
import Starscream
import SwiftyJSON

class ConnectionManager : NSObject, WebSocketDelegate {
    
//    var firebase: Firebase
    var socket: WebSocket
    var room: Room!
    
    var multiPartCounter :Int
    var multiPartBuffer :String
    
    // Singleton
    class var sharedInstance: ConnectionManager {
        struct Static {
            static var instance: ConnectionManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = ConnectionManager()
        }
        
        return Static.instance!
    }
    
    
    override init() {
        self.multiPartCounter = 0
        self.multiPartBuffer = ""
        
        var hostName = "s-dal5-nss-18.firebaseio.com"
        var url = NSURL(scheme: "wss", host: hostName, path: "/.ws?v=5&ns=rdioparty")
        
        self.socket = WebSocket(url:url!)
        super.init()
        
        self.socket.delegate = self
        self.socket.connect()
        
    }
    
    func getPeopleInRoom(room: Room) {
        var json = "{\"t\":\"d\",\"d\":{\"r\":6,\"a\":\"l\",\"b\":{\"p\":\"/\(room.name)/people\",\"h\":\"\"}}}"
        self.socket.writeString(json)
        
        println(json)
    }
    
    func getPlayerInRoom(room: Room) {
        var jsonString = "{\"t\":\"d\",\"d\":{\"r\":8,\"a\":\"l\",\"b\":{\"p\":\"/\(room.name)/player\",\"h\":\"\"}}}"
        self.socket.writeString(jsonString)
    }
    
    func getMessagesInRoom(room: Room) {
        let key = "rdioparty.messagesListChanged"

        var myRootRef = Firebase(url:"https://rdioparty.firebaseio.com/\(room.name)/messages")
        myRootRef.observeEventType(.ChildAdded, withBlock: {
            snapshot in
            var message = Message(fromSnapshot: snapshot.value as! NSObject)
            self.room.messages.append(message)
            NSNotificationCenter.defaultCenter().postNotificationName(key, object: message)
        })

//        var jsonString = "{\"t\":\"d\",\"d\":{\"r\":8,\"a\":\"l\",\"b\":{\"p\":\"/\(room.name)/messages\",\"h\":\"\"}}}"
//        self.socket.writeString(jsonString)
    }
    
    func getRoomListing() {
        var jsonString = "{\"t\":\"d\",\"d\":{\"r\":2,\"a\":\"l\",\"b\":{\"p\":\"/rooms\",\"h\":\"\"}}}"
        println(jsonString)
        self.socket.writeString(jsonString)
    }
    
    func joinRoom(room: Room) {
        self.room = room;
        getPlayerInRoom(room)
        getPeopleInRoom(room)
    }
    
    // MARK: - Websocket callbacks
    
    func websocketDidConnect(socket: WebSocket) {
        println("websocket is connected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        var socketMessage = ""
        
        if let partCounter = text.toInt() {
            self.multiPartCounter = partCounter
            return
        }
        
        if (self.multiPartCounter > 0) {
            println("Piece \(self.multiPartCounter)")
            self.multiPartBuffer += text
            self.multiPartCounter--
            return
        }
        
        if (self.multiPartBuffer != "") {
            socketMessage = self.multiPartBuffer
//            self.multiPartBuffer = ""
        } else {
            socketMessage = text
        }
        
        var json = JSON(data: socketMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
        var type = json["d"]["b"]["p"].stringValue
        var content = json["d"]["b"]["d"]
        println("Type: \(type)")
        
        // Room specific messages
        if let room = room {
            switch type
            {
                case "\(room.name)/people":
                    println("**** People in room message")
                    self.room.people = Person.createArray(content)
                
                case "\(room.name)/messages":
                    println("*** Update messages message")
                    messagesInRoomUpdated(content)
//                    println(content)
                default:
                    println("**** Unknown type: \(type)")
                    println("\(socketMessage)")
            }
        }
    
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        println("got some data: \(data.length)")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        println("Websocket disconnected \(error)")
        //self.socket.disconnect()
        //self.socket.connect()
    }
        

    
    //MARK - Notification center
    
    func messagesInRoomUpdated(messagesJson :JSON) {
//        var messages = Message.createArray(messagesJson)
//        
//        for message in messages {
//            let key = "rdioparty.messagesListChanged"
//            NSNotificationCenter.defaultCenter().postNotificationName(key, object: message)
//        }
    }
    
}