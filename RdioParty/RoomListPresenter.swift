//
//  RoomListPresenter.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/25/15.
//

import UIKit

class RoomListPresenter: Presenter {
    var rooms = Array<Room>()

    override func load() {
        
        var ref = Firebase(url:"https://rdioparty.firebaseio.com/")
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            //println("\(snapshot.key) -> \(snapshot.value)")
            
            if (snapshot.key != nil) {
                var room = Room(fromSnapshot: snapshot)

                if (room.previewPeopleCount > 0) {
                    self.viewController.updateData(room)
                }
            }
        })
        
    }
}
