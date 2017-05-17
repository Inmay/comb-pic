//
//  PictureCollectionViewCell.swift
//  nazApp
//
//  Created by WuYueFeng on 16/8/9.
//  Copyright © 2016年 WuYueFeng. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var coverimg: UIImageView!
    @IBOutlet weak var buttonimg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.backgroundColor = UIColor.blackColor()
    }

}
