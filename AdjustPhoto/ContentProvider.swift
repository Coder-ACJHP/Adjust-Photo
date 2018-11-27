//
//  ContentProvider.swift
//  AdjustPhoto
//
//  Created by Onur Işık on 27.11.2018.
//  Copyright © 2018 Onur Işık. All rights reserved.
//

import UIKit

class ContentProvider {
    
    class func getImageContent() -> [UIImage] {
        return [UIImage(named: "background")!, UIImage(named: "blur")!, UIImage(named: "brightness")!, UIImage(named: "contrast")!, UIImage(named: "highlight")!, UIImage(named: "shadow")!, UIImage(named: "sharpen")!, UIImage(named: "warmth")!]
    }
    
    class func getNamesContent() -> [String] {
        return ["BACKGROUND", "BLUR", "BRIGTNESS", "CONTRAST", "HIGHLIGHT", "SHADOW", "SHARPEN", "WARMTH"]
    }
}
