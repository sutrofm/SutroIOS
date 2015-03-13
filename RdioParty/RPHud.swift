//
//  RPHud.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/8/15.
//

import UIKit

class RPHud: JGProgressHUD {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customize()
    }
    
    override init!(style: JGProgressHUDStyle) {
        super.init(style: style)
        customize()
    }

    func customize() {
        self.interactionType = JGProgressHUDInteractionType.BlockAllTouches
    }
}
