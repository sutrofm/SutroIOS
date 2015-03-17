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
    
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var addedByLabel: UILabel!
    @IBOutlet weak var progressMeter: UIProgressView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        // Set the images as template rendering so we can
        // change their color via tintColor.
        let downVoteImage = UIImage(named:"thumbs-down.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.downVoteButton.setImage(downVoteImage, forState: UIControlState.Normal)
        let favoriteImage = UIImage(named:"favorite.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.favoriteButton.setImage(favoriteImage, forState: UIControlState.Normal)

        updateControlColors()
        
        gradient.colors = [ UIColor.clearColor().CGColor, UIColor.blackColor().colorWithAlphaComponent(0.6).CGColor]
        if (self.gradient.superlayer == nil) {
            self.layer.insertSublayer(self.gradient, atIndex: 0)
        }
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
