//
//  images.swift
//  组合图片
//
//  Created by WuYueFeng on 2017/5/17.
//  Copyright © 2017年 WuYueFeng. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init!(name:imageName) {
        self.init(named:name.rawValue)
    }
}

enum imageName : String{
    
    
    case messimg = "popover_noarrow_background"   //弹出提醒
    
    case gray_select = "gou_white"
    case blue_select = "gou_blue"
    case yuan = "yuan"
    case stop = "new"
    case into = "into"
    
}
