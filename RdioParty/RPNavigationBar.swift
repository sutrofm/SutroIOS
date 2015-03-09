//
//  RPNavigationBar.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//

import UIKit

class RPNavigationBar: UINavigationBar {

    var secondaryLabelText :String! {
        didSet {
            updateSecondaryLabel()
        }
    }
    
    var secondaryLabel :UILabel!
    
    required override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSecondaryLabel()
        customizeNavbar()
    }
    
    func updateSecondaryLabel() {
        if let text = self.secondaryLabelText {
            self.secondaryLabel.text = self.secondaryLabelText
        }
        customizeNavbar()
    }
    
    func customizeNavbar() {
        var veriticalOffset = CGFloat(0)
        if self.secondaryLabelText != nil {
            veriticalOffset = -6
            self.secondaryLabel.hidden = false
        } else {
            self.secondaryLabel.hidden = true
        }
        self.setTitleVerticalPositionAdjustment(veriticalOffset, forBarMetrics: UIBarMetrics.Default)
    }
    
    func createSecondaryLabel() {
        let labelHight = CGFloat(15)
        self.secondaryLabel = UILabel()
        self.secondaryLabel.textAlignment = NSTextAlignment.Center
        self.secondaryLabel.font = UIFont(name: self.secondaryLabel.font.familyName, size: 10)
        self.secondaryLabel.frame = CGRectMake(5, self.frame.size.height - labelHight - 2, self.frame.size.width - 10, labelHight)
        self.addSubview(self.secondaryLabel)
    }

}
