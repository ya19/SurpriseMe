//
//  ShopCollectionViewCell.swift
//  SurpriseMe
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var shopLogo: UIImageView!
    
    func populate(image: UIImage?){
        shopLogo.image = image
    }
    
}
