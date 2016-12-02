//
//  ShopListTableViewCell.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 12/2/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit

class ShopListTableViewCell: UITableViewCell {

    @IBOutlet weak var shoppinglist: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
