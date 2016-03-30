//
//  Utils.swift
//  CodeHighlighting
//
//  Created by YuPengyang on 3/30/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = startIndex.advancedBy(r.endIndex - r.startIndex)
            return self[startIndex ..< endIndex]
        }
    }
}

// MARK: - UIColor
extension UIColor {
    convenience init(rgb: UInt) {
        self.init(red: CGFloat((rgb & 0xff0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00ff00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000ff) / 255.0,
                  alpha: CGFloat(1))
    }
    
    convenience init(rgbString: String) {
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        let str = rgbString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        var start = -1
        if str.hasPrefix("#") && str.characters.count == 7 {
            start = 1
        } else if str.hasPrefix("0X") && str.characters.count == 9 {
            start = 2
        }
        
        if (start >= 0) {
            let rStr = str[start..<start+2]
            let gStr = str[start+2..<start+4]
            let bStr = str[start+4..<start+6]
            NSScanner(string: rStr).scanHexInt(&r)
            NSScanner(string: gStr).scanHexInt(&g)
            NSScanner(string: bStr).scanHexInt(&b)
        }
        
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    convenience init(rgb: UInt, alpha: CGFloat) {
        self.init(red: CGFloat((rgb & 0xff0000) >> 16) / 255.0,
                  green: CGFloat((rgb & 0x00ff00) >> 8) / 255.0,
                  blue: CGFloat(rgb & 0x0000ff) / 255.0,
                  alpha: CGFloat(alpha))
    }
}