//
//  ChatPresenter.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/25/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatPresenter: Presenter {
    var messages = Array<Message>()
    
    override func load() {
        
        var ref = Firebase(url:"https://rdioparty.firebaseio.com/test1234/messages")
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            println("\(snapshot.key) -> \(snapshot.value)")
            
            if (snapshot.key != nil) {
                var message = Message(fromSnapshot: snapshot)
                self.viewController.updateData(message)
            }
        })
        
    }
}