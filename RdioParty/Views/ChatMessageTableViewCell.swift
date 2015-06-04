//
//  ChatMessageTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/25/15.
//  Copyright (c) 2015 Rdio. All rights reserved.
//

import UIKit

class ChatMessageTableViewCell: UITableViewCell {

    let imageSize = CGFloat(50)
    
    let marginSize = CGFloat(10)
    let cellPadding = CGFloat(7)
    
    var userImage = UIImageView.newAutoLayoutView()
    var userName = UILabel.newAutoLayoutView()
    var messageText = ChatMessageContentTextView.newAutoLayoutView()
    var backingView = CutOutView.newAutoLayoutView()
    
    var didSetupConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupViews()
    }
    
    func setupViews() {
        
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        backingView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        messageText.backgroundColor = UIColor.clearColor()

        contentView.addSubview(backingView)
        backingView.addSubview(userName)
        contentView.addSubview(userImage)
        backingView.addSubview(messageText)

        self.userImage.clipsToBounds = true
                
        // This is the area that the user icon takes up on top of the cell, so we make
        // the text "wrap" around it.
        // TODO: Find a way to do this nicely without magic numbers.
        let exclusionFrame = CGRectMake(0, 0, 50, 10)
        let exclusionPath = UIBezierPath(rect: exclusionFrame)
        messageText.textContainer.exclusionPaths = [exclusionPath]
        
        userImage.layer.cornerRadius = CGFloat(imageSize / 2)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            // User image
            userImage.autoPinEdgeToSuperviewEdge(.Top, withInset: 5)
            userImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: marginSize)
            userImage.autoSetDimensionsToSize(CGSize(width: imageSize, height: imageSize))

            // User name
            userName.autoPinEdge(.Leading, toEdge: .Trailing, ofView: userImage, withOffset: marginSize)
            userName.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            userName.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            
            // Message body is aligned under the name, but the first line is equal to the left spacing
            messageText.autoPinEdge(.Top, toEdge: .Bottom, ofView: userName, withOffset: 5)
            messageText.autoPinEdgeToSuperviewEdge(.Leading, withInset: marginSize)
            messageText.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            messageText.autoSetDimension(.Height, toSize: 15, relation: NSLayoutRelation.GreaterThanOrEqual)

            // Backing view runs the top to the bottom
            backingView.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            backingView.autoPinEdgeToSuperviewEdge(.Leading, withInset: cellPadding)
            backingView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            backingView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: messageText, withOffset: cellPadding)

            // Content View
            contentView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 0)
            contentView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 0)
            contentView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
            contentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: backingView, withOffset: cellPadding)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        userName.preferredMaxLayoutWidth = userName.bounds.width
//    }
}
