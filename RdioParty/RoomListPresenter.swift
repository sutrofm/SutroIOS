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
                var room = Room(fromName: snapshot.key)
                if (snapshot.value.objectForKey("meta") != nil) {
                    let metaObject = snapshot.value.objectForKey("meta") as! NSObject
                    room.theme = metaObject.valueForKey("themeText") as! String
                }
                
                // Messy way of determining if there are active people in this room.
                // Can't I just use a predicate or something?  It doesn't help that these
                // are non-swift objects either, I suppose.  Will get back to this.
                var peopleOnline = 0
                if ((snapshot.value.objectForKey("people") != nil)) {
                    let peopleObject = snapshot.value.objectForKey("people") as! NSDictionary
                    let peopleKeys = peopleObject.allKeys
                    
                    for key in peopleKeys {
                        let person: NSDictionary? = peopleObject.objectForKey(key) as? NSDictionary
                        if (person?.valueForKey("isOnline") as! Bool) {
                            peopleOnline++
                        }
                    }
                    
                    if (peopleOnline > 0) {
                        room.previewPeopleCount = peopleOnline
                        self.viewController.updateData(room)
                    }
                }
            }
        })
        
    }
}
