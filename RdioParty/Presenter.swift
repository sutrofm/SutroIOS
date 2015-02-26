//
//  Presenter.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/25/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class Presenter: NSObject {
    var viewController :RdioPartyViewController
    
    init(viewController :RdioPartyViewController) {
        self.viewController = viewController
        super.init()
        load()
    }
    
    func load() {
        fatalError("This method must be overridden")
    }
}
