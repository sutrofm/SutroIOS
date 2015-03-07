//
//  RPParallaxImageView.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/7/15.
//

import UIKit

class RPParallaxImageView: UIImageView {
    let movementAmount = CGFloat(50.0)
    
    override init() {
        super.init()
        addParallax()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init(image: UIImage!) {
        super.init(image: image)
    }
    
    override func layoutSubviews() {
        var originalFrame = self.frame
        var updatedFrame = CGRectMake((movementAmount * -1), originalFrame.origin.y, originalFrame.size.width + (movementAmount * 4.0), originalFrame.size.height)
        self.frame = updatedFrame
    }

    func addParallax() {
        self.clipsToBounds = true
        var parallaxEffect : UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",type: .TiltAlongHorizontalAxis)
        parallaxEffect.minimumRelativeValue = -movementAmount / 2.0
        parallaxEffect.maximumRelativeValue = movementAmount / 2.0
        self.addMotionEffect(parallaxEffect)
    }
}
