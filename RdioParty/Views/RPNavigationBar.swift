//
//  RPNavigationBar.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//

import UIKit

class RPNavigationBar: UINavigationBar {
    let customTitleLabel = UILabel()
    
    var secondaryLabelText :String! {
        didSet {
            updateSecondaryLabel()
        }
    }
    
    var secondaryLabel :UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customTitleLabel.textAlignment = NSTextAlignment.Center
        addSubview(customTitleLabel)
    }
    
    override func layoutSubviews() {
        createSecondaryLabel()
        customizeNavbar()
        customTitleLabel.frame = CGRectMake(20, 5, frame.size.width - 40, 20)
    }
    
    func setTitle(customTitle :String) {
        UIView.transitionWithView(customTitleLabel, duration: 0.3, options: UIViewAnimationOptions.TransitionFlipFromTop, animations: { () -> Void in
            self.customTitleLabel.text = customTitle
        }, completion: nil)

    }
    
    func updateSecondaryLabel() {
        if let text = self.secondaryLabelText {
            secondaryLabel.text = self.secondaryLabelText
        }
        customizeNavbar()
    }
    
    
    func customizeNavbar() {
        var veriticalOffset = CGFloat(0)
        if secondaryLabelText != nil {
            veriticalOffset = -10
            secondaryLabel.hidden = false
        } else {
            secondaryLabel.hidden = true
        }


        setTitleVerticalPositionAdjustment(veriticalOffset, forBarMetrics: UIBarMetrics.Default)
//        backIndicatorImage = UIImage(named: "rooms")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal).imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -3, 0))
//        backIndicatorTransitionMaskImage = UIImage(named: "rooms")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal).imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -3, 0))
    }
    
    func createSecondaryLabel() {
        let labelHight = CGFloat(15)
        if (secondaryLabel == nil) {
            secondaryLabel = UILabel()
        }
        secondaryLabel.textAlignment = NSTextAlignment.Center
        secondaryLabel.font = UIFont(name: self.secondaryLabel.font.familyName, size: 10)
        secondaryLabel.frame = CGRectMake(5, self.frame.size.height - labelHight - 2, self.frame.size.width - 10, labelHight)
        addSubview(self.secondaryLabel)
    }

}
