//
//  Utils.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//

import UIKit

class Utils: NSObject {
    
    static func secondsToHoursMinutesSecondsString (seconds : Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let secs = (seconds % 36) % 60
        
        let string = "\(minutes):\(secs)"

        return string
    }
    
}
