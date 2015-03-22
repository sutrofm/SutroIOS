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
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        backingView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        self.messageText.backgroundColor = UIColor.clearColor()

        contentView.addSubview(backingView)
        backingView.addSubview(userName)
        contentView.addSubview(userImage)
        backingView.addSubview(messageText)

        self.userImage.clipsToBounds = true
                
        // This is the area that the user icon takes up on top of the cell, so we make
        // the text "wrap" around it.
        // TODO: Find a way to do this nicely without magic numbers.
        let exclusionFrame = CGRectMake(0, 0, 53, 10)
        let exclusionPath = UIBezierPath(rect: exclusionFrame)
        self.messageText.textContainer.exclusionPaths = [exclusionPath]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            // User image
            userImage.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            userImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: 20)
            userImage.autoSetDimensionsToSize(CGSize(width: imageSize, height: imageSize))

            // User name
            userName.autoPinEdge(.Leading, toEdge: .Trailing, ofView: userImage, withOffset: 5)
            userName.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            userName.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            
            // Message body is aligned under the name, but the first line is equal to the left spacing
            messageText.autoPinEdge(.Top, toEdge: .Bottom, ofView: userName, withOffset: 5)
            messageText.autoPinEdgeToSuperviewEdge(.Leading, withInset: marginSize)
            messageText.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            messageText.autoSetDimension(.Height, toSize: 15, relation: NSLayoutRelation.GreaterThanOrEqual)

            // Backing view runs the top to the bottom
            backingView.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            backingView.autoPinEdgeToSuperviewEdge(.Leading, withInset: marginSize)
            backingView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            backingView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: messageText, withOffset: marginSize)

            // Content View
            contentView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 0)
            contentView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 0)
            contentView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
            contentView.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: backingView, withOffset: 5)
            
            // Needs to be set after the size of the image is set
            self.userImage.layer.cornerRadius = CGFloat(imageSize / 2)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}
