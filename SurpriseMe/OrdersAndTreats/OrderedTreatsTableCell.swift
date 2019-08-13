//
//  OrderedTreatsTableCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class OrderedTreatsTableCell: UITableViewCell {
    
    @IBOutlet weak var treatStatus: UIImageView!
    @IBOutlet weak var treatPrice: UILabel!
    
    @IBOutlet weak var treatImage: UIImageView!
    
    @IBOutlet weak var treatGetter: UILabel!
    
    @IBOutlet weak var dateOfOrder: UILabel!
    
    @IBOutlet weak var productName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(treat: Treat,getter: String){
        treatImage.image = treat.product.image
//        treatGetter.text = "\(treat.getter?.firstName) \(treat.getter?.lastName)"
        treatGetter.text = getter
        dateOfOrder.text = treat.dateString
        productName.text = treat.product.name
        treatStatus.image = treat.treatStatus!.image
        treatPrice.text = "\(treat.product.price) ₪"
        
        switch treat.treatStatus!{
        case .Declined : treatPrice.textColor = UIColor.red
            
        default: treatPrice.textColor = UIColor(red: 0/255, green: 181/255, blue: 51/255, alpha: 1.0)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
