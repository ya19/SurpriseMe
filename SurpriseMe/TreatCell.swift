//
//  TreatCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class TreatCell: UITableViewCell {

    @IBOutlet weak var treatImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var giver: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var delegate:UseTreatDelegate?
    var treat:Treat?
    
    
    @IBAction func useCoupon(_ sender: UIButton) {
        
        delegate?.useTreat(treat: treat!)
    }
    
    func populate(treat: Treat){
        self.treat = treat
        treatImage.image = treat.product.image
        productName.text = treat.product.name
        giver.text = "The giver's name" //treat.giver?.firstName
        dateLabel.text = "Date of the order"
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }



}
