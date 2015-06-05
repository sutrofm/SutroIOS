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
    
    override func awakeFromNib() {
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
    }
    
    override func layoutSubviews() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: frame, byRoundingCorners: .TopLeft, cornerRadii: CGSize(width: 25.0, height: 20.0)).CGPath
        
        layer.mask = maskLayer;
    }

}
