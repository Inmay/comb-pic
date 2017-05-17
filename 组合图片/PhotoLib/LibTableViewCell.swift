//
//  LibTableViewCell.swift
//  FileManager
//
//  Created by WuYueFeng on 16/8/11.
//  Copyright © 2016年 WuYueFeng. All rights reserved.
//

import UIKit

class LibTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
