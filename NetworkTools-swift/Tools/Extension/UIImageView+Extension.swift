//
//  UIImageView+Extension.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/22.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit


extension UIImageView {

    convenience init(imageName:String){
        self.init(image:UIImage(named: imageName))
    }
}
