//
//  ChatTrackChangedTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/1/15.
//

import UIKit

class ChatTrackChangedTableViewCell: UITableViewCell {

    var trackImage = UIImageView.newAutoLayoutView()
    var trackName = UILabel.newAutoLayoutView()
    var artistName = UILabel.newAutoLayoutView()
    var userImage = UIImageView.newAutoLayoutView()
    var backingView = UIView.newAutoLayoutView()
    
    var didSetupConstraints = false

    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        backingView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
        
        clipsToBounds = true
        backingView.layer.cornerRadius = 10.0
        
        userImage.clipsToBounds = false
        userImage.layer.cornerRadius = self.userImage.frame.size.width / 2
        userImage.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        userImage.layer.borderWidth = CGFloat(0.5)
        
        artistName.textColor = UIColor.whiteColor()
        trackName.textColor = UIColor.whiteColor()
        
        trackName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        artistName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)

        contentView.addSubview(backingView)
        backingView.addSubview(trackImage)
        backingView.addSubview(trackName)
        backingView.addSubview(artistName)
        trackImage.addSubview(userImage)
    }
        
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            // Track image
            let imageSize = CGFloat(35)
            trackImage.autoPinEdgeToSuperviewEdge(.Top, withInset: 3)
            trackImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: 20)
            trackImage.autoSetDimensionsToSize(CGSize(width: imageSize, height: imageSize))

            // User image on top of the track image in the bottom right corner
            userImage.autoPinEdgeToSuperviewEdge(.Bottom, withInset: -5)
            userImage.autoPinEdgeToSuperviewEdge(.Trailing, withInset: -5)
            userImage.autoSetDimensionsToSize(CGSize(width: 18, height: 18))

            // Track name is top aligned and to the right of the track image
            trackName.autoPinEdge(.Top, toEdge: .Top, ofView: trackImage)
            trackName.autoPinEdge(.Leading, toEdge: .Trailing, ofView: trackImage, withOffset: 10)
            trackName.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 5)
            
            // Artist name is aligned under the track name to the right of the track image
            artistName.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: trackImage)
            artistName.autoPinEdge(.Leading, toEdge: .Leading, ofView: trackName)
            artistName.autoPinEdge(.Leading, toEdge: .Trailing, ofView: trackImage, withOffset: 10)
            
            // The backing view is the content view, with some padding
            let inset = CGFloat(3)
            backingView.autoPinEdgeToSuperviewEdge(.Top, withInset: inset)
            backingView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 0)
            backingView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: inset)
            backingView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 0)
//            backingView.autoSetDimension(.Height, toSize: 40)
            
            // Content View
//            contentView.autoPinEdgeToSuperviewEdge(.Leading, withInset: 0)
//            contentView.autoPinEdgeToSuperviewEdge(.Trailing, withInset: 0)
//            contentView.autoPinEdgeToSuperviewEdge(.Top, withInset: 0)
//            contentView.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 0)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    override func prepareForReuse() {
        backingView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
