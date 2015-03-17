//
//  PersonListTableViewCell.swift
//  RdioParty
//
//  Created by Gabe Kangas on 3/12/15.
//

import UIKit

class PersonListTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView!.clipsToBounds = true
        imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        textLabel!.font = UIFont(name: textLabel!.font.familyName, size: 20)
        textLabel!.textColor = UIColor.whiteColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView!.frame = CGRectMake(imageView!.frame.origin.x, imageView!.frame.origin.y, imageView!.frame.size.height, imageView!.frame.size.height) // Make square
        imageView!.layer.cornerRadius = imageView!.frame.size.height / 2
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
