//
//  SavedVideoTableViewCell.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 11/30/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit

class SavedVideoTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        name.font = UIFont (name: "Avenir", size: 17)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
