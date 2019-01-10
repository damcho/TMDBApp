//
//  VideoTableViewCell.swift
//  TMDBApp
//
//  Created by Damian Modernell on 10/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitleLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
