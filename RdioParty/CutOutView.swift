//
//  CutOutView.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//
// This is a background view of a Chat message cell.  It cuts out the view where
// the user image is as a neat styistic thing.
import UIKit

class CutOutView: UIView {
    let backingView = UIView(frame: CGRectZero)
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clearColor()
        self.backingView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        self.insertSubview(backingView, atIndex: 0)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .TopLeft, cornerRadii: CGSize(width: 15.0, height: 10.0)).CGPath
        
        self.backingView.layer.mask = maskLayer;
    }

    override func layoutSubviews() {
        self.backingView.frame = CGRectMake(0, 10, self.frame.size.width, self.frame.size.height - 20)
    }
//
//    override func viewWillLayoutSubviews() {
//        
//    }
//    
//    override func drawRect(rect: CGRect) {
//        var maskPath = UIBezierPath(roundedRect: self.backingView.frame, byRoundingCorners: UIRectCorner.TopLeft, cornerRadii: CGSizeMake(5, 5))
//        var maskLayer = CAShapeLayer()
//        maskLayer.frame = self.backingView.frame
//        maskLayer.path = maskPath.CGPath
//        self.backingView.layer.mask = maskLayer
//    }
}
