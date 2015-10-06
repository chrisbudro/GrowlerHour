//
//  BrowseViewCell.swift
//  growlers
//
//  Created by Mac Pro on 5/6/15.
//  Copyright (c) 2015 chrisbudro. All rights reserved.
//

import UIKit

class BrowseViewCell: UITableViewCell {
    
    @IBOutlet weak var browseByLabel: UILabel!
    @IBOutlet weak var browseByImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
