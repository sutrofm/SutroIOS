//
//  NSDate+Extensions.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/20/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

extension NSDate {
    var formatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.stringFromDate(self)
    }
}