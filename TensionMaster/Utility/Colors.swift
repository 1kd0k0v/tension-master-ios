//
//  Colors.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 2/6/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: a)
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(red: (rgb >> 16) & 0xFF,
                  green: (rgb >> 8) & 0xFF,
                  blue: rgb & 0xFF,
                  a: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: CGFloat(a) / 255.0)
    }
    
    // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(red: (argb >> 16) & 0xFF,
                  green: (argb >> 8) & 0xFF,
                  blue: argb & 0xFF,
                  a: (argb >> 24) & 0xFF)
    }
    
}

extension UIColor {
    
    class var backgroundDark: UIColor {
        return UIColor(rgb: 0x2A3652)
    }
    
    class var backgroundLight: UIColor {
        return UIColor(rgb: 0x3F4A6D)
    }
    
    class var circleStart: UIColor {
        return UIColor(rgb: 0x947FEE)
    }
    
    class var circleEnd: UIColor {
        return UIColor(rgb: 0xF74A8E)
    }
    
    class var accent: UIColor {
        return UIColor(rgb: 0xC17AD3)
    }
    
    class var soundIndicator: UIColor {
        return UIColor.circleStart
    }
    
    class var mainText: UIColor {
        return UIColor.white
    }
    
    class var secondaryText: UIColor {
        return UIColor(argb: 0xBBFFFFFF)
    }

}
