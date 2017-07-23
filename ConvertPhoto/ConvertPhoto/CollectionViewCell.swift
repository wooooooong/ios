//
//  CollectionViewCell.swift
//  ConvertPhoto
//
//  Created by woowabrothers on 2017. 7. 23..
//  Copyright © 2017년 woowabrothers. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    override var isSelected: Bool{
        didSet{
            if isSelected {
                image.layer.borderColor = UIColor.red.cgColor
                image.layer.borderWidth = 1.0
            } else {
                image.layer.borderWidth = 0.0
            }
        }
    }
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
}
