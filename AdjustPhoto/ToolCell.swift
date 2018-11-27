//
//  ToolCell.swift
//  AdjustPhoto
//
//  Created by Onur Işık on 27.11.2018.
//  Copyright © 2018 Onur Işık. All rights reserved.
//

import UIKit

class ToolCell: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        didSet {
            
            if self.isSelected {
                
                UIView.animate(withDuration: 0.3) {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
                
            } else {
                
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
}
