//
//  ProductCollectionViewCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 12/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productLogo: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPriceText: UILabel!
    
//    func popoulate(productName: String , productImage: UIImage , productPrice: Double){
//        productName.text = productName
//        productLogo.image = productImage
//        productPriceText.text = "\(productPrice) NIS"
//    }
    
    
    func populate(product: Product){
        
//        productName.layer.cornerRadius = 15.0
//        productPriceText.layer.cornerRadius = 15.0
        self.layer.cornerRadius = 20.0
        productName.text = product.name
        productLogo.image = product.image
        productPriceText.text = "\(product.price) ₪"
    }
}
