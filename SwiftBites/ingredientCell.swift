//
//  ingredientCell.swift
//  SwiftBites
//
//  Created by Ziyun Zheng on 12/2/16.
//  Copyright © 2016 Ziyun Zheng. All rights reserved.
//

import UIKit

class ingredientCell: UITableViewCell {

    @IBOutlet weak var checked: UIButton!
    @IBOutlet weak var ingredient: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        ingredient.font = UIFont (name: "Avenir", size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    /*
     // MARK: - change the image for the checked recipe
     */
    func setChecked(){
        self.checked.setImage(UIImage(named: "checked.png"), for: UIControlState.normal)
    }
    /*
     // MARK: - change the image for the unchecked recipe
     */
    func setUnchecked(){
        self.checked.setImage(UIImage(named: "unchecked.png"), for: UIControlState.normal)
    }
    
}
