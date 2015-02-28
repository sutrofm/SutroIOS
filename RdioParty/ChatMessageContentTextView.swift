//
//  ChatMessageContentTextView.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatMessageContentTextView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.

    */
    
    override func drawRect(rect: CGRect) {
        self.textContainer.lineFragmentPadding = 3
        self.textContainerInset = UIEdgeInsetsZero
    }

}
