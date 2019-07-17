//
//  OrderedTreatsTableCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class OrderedTreatsTableCell: UITableViewCell {
    
    
    @IBOutlet weak var treatImage: UIImageView!
    
    @IBOutlet weak var treatGetter: UILabel!
    
    @IBOutlet weak var dateOfOrder: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(treat: Treat){
        treatImage.image = treat.product.image
        treatGetter.text = "\(treat.getter?.firstName) \(treat.getter?.lastName)"
        dateOfOrder.text = "When you ordered"
        productName.text = treat.product.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
