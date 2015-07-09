//
//  QueueItemCellTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 2/28/15.
//

import UIKit

class QueueItemCellTableViewCell: UITableViewCell {

    var trackImage = UIImageView.newAutoLayoutView()
    var trackName = UILabel.newAutoLayoutView()
    var trackArtist = UILabel.newAutoLayoutView()
    var userAddedLabel = UILabel.newAutoLayoutView()
    var trackLength = UILabel.newAutoLayoutView()
    
    var voteUpButton = UIButton.newAutoLayoutView()
    var voteDownButton = UIButton.newAutoLayoutView()
    
    let marginSize = CGFloat(10)
    let textPadding = CGFloat(2)
    let imageSize = CGFloat(80)
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareForReuse()
        
        // Initialization code
    }
    
    func setupViews() {
        let textColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        
        trackName.textColor = textColor
        trackArtist.textColor = textColor
        userAddedLabel.textColor = textColor
        trackLength.textColor = textColor
        
        trackName.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        trackArtist.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
        userAddedLabel.font = trackArtist.font
        trackLength.font = trackArtist.font
        
        contentView.addSubview(trackImage)
        contentView.addSubview(trackName)
        contentView.addSubview(trackArtist)
        contentView.addSubview(userAddedLabel)
        contentView.addSubview(trackLength)
        
//        TODO: Once the new backend is live wire up voting
//        contentView.addSubview(voteUpButton)
//        contentView.addSubview(voteDownButton)
        
    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {

            // Track image
            trackImage.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            trackImage.autoPinEdgeToSuperviewEdge(.Leading, withInset: marginSize)
            trackImage.autoSetDimensionsToSize(CGSize(width: imageSize, height: imageSize))
            
            // Track name
            trackName.autoPinEdge(.Leading, toEdge: .Trailing, ofView: trackImage, withOffset: marginSize)
            trackName.autoPinEdgeToSuperviewEdge(.Top, withInset: marginSize)
            trackName.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            
            // Artist name
            trackArtist.autoPinEdge(.Leading, toEdge: .Trailing, ofView: trackImage, withOffset: marginSize)
            trackArtist.autoPinEdge(.Top, toEdge: .Bottom, ofView: trackName, withOffset: textPadding)
            trackArtist.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)
            
            // Added by
            userAddedLabel.autoPinEdge(.Leading, toEdge: .Trailing, ofView: trackImage, withOffset: marginSize)
            userAddedLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: trackArtist, withOffset: textPadding)
            userAddedLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: marginSize)

            // Track duration
            trackLength.autoPinEdge(.Leading, toEdge: .Trailing, ofView: trackImage, withOffset: marginSize)
            trackLength.autoPinEdge(.Top, toEdge: .Bottom, ofView: userAddedLabel, withOffset: textPadding)
            
            didSetupConstraints = true

        }
        
        super.updateConstraints()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        userAddedLabel.text = ""
    }

}
