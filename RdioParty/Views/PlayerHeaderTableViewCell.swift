//
//  PlayerHeaderTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/6/15.
//

import UIKit

class PlayerHeaderTableViewCell: UITableViewCell {

    var gradient = CAGradientLayer()
    var currentSongDuration :Float = 0.0
    var currentSongColor = UIColor.whiteColor() {
        didSet {
            updateControlColors()
        }
    }
    
    var playing = false {
        didSet {
            updatePlayPauseButton()
        }
    }
    
    var playPauseButton = UIButton.newAutoLayoutView()
    var favoriteButton = UIButton.newAutoLayoutView()
    var downVoteButton = UIButton.newAutoLayoutView()
    var trackNameLabel = UILabel.newAutoLayoutView()
    var artistNameLabel = UILabel.newAutoLayoutView()
    var addedByLabel = UILabel.newAutoLayoutView()
    var progressMeter = UIProgressView.newAutoLayoutView()
    var durationLabel = UILabel.newAutoLayoutView()
    var progressLabel = UILabel.newAutoLayoutView()
    
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
        
//        contentView.addSubview(playPauseButton)
//        contentView.addSubview(favoriteButton)
//        contentView.addSubview(downVoteButton)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(addedByLabel)
        contentView.addSubview(progressMeter)
        contentView.addSubview(durationLabel)
        contentView.addSubview(progressLabel)
        
        let textColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        playPauseButton.setTitleColor(textColor, forState: .Normal)
        favoriteButton.setTitleColor(textColor, forState: .Normal)
        downVoteButton.setTitleColor(textColor, forState: .Normal)
        trackNameLabel.textColor = textColor
        artistNameLabel.textColor = textColor
        addedByLabel.textColor = textColor
        durationLabel.textColor = textColor
        progressLabel.textColor = textColor
        
        // Drop shadow
        let shadowColor = UIColor.blackColor().CGColor
        trackNameLabel.layer.shadowColor = shadowColor
        trackNameLabel.layer.shadowOffset = CGSize(width: -1, height: -1)
        trackNameLabel.layer.shadowOpacity = 0.7
        
        artistNameLabel.layer.shadowColor = trackNameLabel.layer.shadowColor
        artistNameLabel.layer.shadowOffset = trackNameLabel.layer.shadowOffset
        artistNameLabel.layer.shadowOpacity = trackNameLabel.layer.shadowOpacity
        
        trackNameLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        artistNameLabel.font = trackNameLabel.font
        addedByLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        progressLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption2)
        durationLabel.font = progressLabel.font

        trackNameLabel.textAlignment = .Center
        artistNameLabel.textAlignment = .Center
        addedByLabel.textAlignment = .Center
        
        // Set the images as template rendering so we can
        // change their color via tintColor.
        let downVoteImage = UIImage(named:"thumbs-down.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.downVoteButton.setImage(downVoteImage, forState: UIControlState.Normal)
        let favoriteImage = UIImage(named:"favorite.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.favoriteButton.setImage(favoriteImage, forState: UIControlState.Normal)
        
        contentView.backgroundColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
        
        gradient.colors = [ UIColor.clearColor().CGColor, UIColor.blackColor().colorWithAlphaComponent(0.6).CGColor]
        layer.insertSublayer(self.gradient, atIndex: 0)

        updateControlColors()

    }
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            let textSpacing = CGFloat(5)
            
            // Track name
            trackNameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 60)
            trackNameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: textSpacing)
            trackNameLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: textSpacing)
            
            // Artist name
            artistNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: trackNameLabel, withOffset: textSpacing)
            artistNameLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: textSpacing)
            artistNameLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: textSpacing)

            // Added by is pinned to the bottom
            addedByLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 10)
            addedByLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: textSpacing)
            addedByLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: textSpacing)
            
            let progressY = CGFloat(110)
            
            // Progress
            progressLabel.autoPinEdgeToSuperviewEdge(.Leading, withInset: textSpacing)
            progressLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: progressY)
            
            // Duration
            durationLabel.autoPinEdgeToSuperviewEdge(.Trailing, withInset: textSpacing)
            durationLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: progressY)
            
            // Progress bar
            progressMeter.autoPinEdgeToSuperviewEdge(.Top, withInset: progressY + 5)
            progressMeter.autoPinEdge(.Leading, toEdge: .Trailing, ofView: progressLabel, withOffset: 10)
            progressMeter.autoPinEdge(.Trailing, toEdge: .Leading, ofView: durationLabel, withOffset: -5)
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        self.gradient.frame = self.bounds
        super.layoutSubviews()
    }
    
    func setProgress(progress: Float) {
        self.progressLabel.text = Utils.secondsToHoursMinutesSecondsString(Int(progress))
        if (progress > 0 && self.currentSongDuration > 0) {
            var progressValue = progress / self.currentSongDuration
            self.progressMeter.progress = progressValue
        }
    }
    
    func setDuration(duration: Int) {
        self.currentSongDuration = Float(duration)
        self.durationLabel.text = Utils.secondsToHoursMinutesSecondsString(duration)
    }
    
    func updateControlColors() {
        self.progressMeter.tintColor = self.currentSongColor

        // Using the song color looks stupid on these buttons.  Get back to this.
        let buttonColor = UIColor.whiteColor()
        self.favoriteButton.tintColor = buttonColor
        self.downVoteButton.tintColor = buttonColor
        self.playPauseButton.tintColor = buttonColor
    }
    
    func updatePlayPauseButton() {
        var playPauseImage :UIImage
        if (self.playing) {
            playPauseImage = UIImage(named:"controls_pause.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        } else {
            playPauseImage = UIImage(named:"controls_play.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        self.playPauseButton.setImage(playPauseImage, forState: UIControlState.Normal)

    }

}
