//
//  Utils.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//

import UIKit

class Utils: NSObject {
    
    static func secondsToHoursMinutesSecondsString (totalSeconds : Int) -> String {
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        let hours = totalSeconds / 3600
        let strHours = hours > 9 ? String(hours) : "0" + String(hours)
        let strMinutes = minutes > 9 ? String(minutes) : "0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds) : "0" + String(seconds)
        
        if hours > 0 {
            return "\(strHours):\(strMinutes):\(strSeconds)"
        }
        else {
            return "\(strMinutes):\(strSeconds)"
        }

    }
    
}
