//
//  OrderCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var viewProductsBtn: SAButton!
    
    var order : Order?
    
    var delegate : ShowPopUpDelegate?
    @IBAction func showProducts(_ sender: UIButton) {
        delegate?.showTreats(order: order!)
    }
    
//    func populate (order : Order){
//        self.order = order!
//        idLabel.text = order.id
//        //to do: don't forget to make the calculation ahead.
//        priceLabel.text = "\(order.price)"
//        dateLabel.text = order.dateString
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
