//
//  UIButton+Extension.swift
//  weiBo
//
//  Created by Mr.Q on 16/7/22.
//  Copyright © 2016年 MrQ. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(imageName:String , backImageName:String?){

        self.init()

        setImage(UIImage(named: imageName), forState: .Normal)
        setImage(UIImage(named: imageName+"_highlighted"),forState: .Highlighted)

        if let backImgName = backImageName{

            setBackgroundImage(UIImage(named: backImgName), forState: .Normal)
            setBackgroundImage(UIImage (named: backImgName + "_highlighted"), forState: .Highlighted)

        }

        sizeToFit()
    }

    convenience init (title: String ,
        fontSize:CGFloat = 18,
        color:UIColor = UIColor.lightGrayColor(),
        backImageName: String?){

        self.init()

        setTitle(title, forState: .Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        setTitleColor(color, forState: .Normal)

        if let backImgName = backImageName{

            setBackgroundImage(UIImage(named: backImgName), forState: .Normal)
            
        }
        sizeToFit()
    }

    convenience init(title: String,
        fontSize: CGFloat,
        color:UIColor = UIColor.lightGrayColor(),
        imageName: String) {

        self.init()

        setTitle(title, forState: .Normal)
        setTitleColor(color, forState: .Normal)
        setImage(UIImage(named: imageName), forState: .Normal)

        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        
        sizeToFit()
    }
}
