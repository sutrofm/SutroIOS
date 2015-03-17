//
//  UIApplication+Extensions.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/9/15.
//

import UIKit

extension UIApplication {

    static var rdioPartyApp :AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
