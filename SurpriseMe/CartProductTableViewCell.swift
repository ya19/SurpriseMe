//
//  CartProductTableViewCell.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 12/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CartProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        initCell()
        // Configure the view for the selected state
    }
}
