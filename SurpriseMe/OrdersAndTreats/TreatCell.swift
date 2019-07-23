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
    
    var delegate:ShowPopUpDelegate?
    var treat:Treat?
    
    @IBOutlet weak var treatStatusImage: UIImageView!
    
    @IBOutlet weak var treatStatusLabel: UILabel!
    
    @IBOutlet weak var useTreatBtn: UIButton!
    
    
    
    
    @IBAction func useCoupon(_ sender: UIButton) {
        
        delegate?.useTreat(treat: treat!)
    }
    
    func populate(treat: Treat){
        self.treat = treat
        treatImage.image = treat.product.image
        productName.text = treat.product.name
        giver.text = "The giver's name" //treat.giver?.firstName
        dateLabel.text = treat.dateString
        
        switch treat.getUpdatedStatus!{
        case .NotUsed:
            treatStatusImage.isHidden = true
            treatStatusLabel.isHidden = true
            useTreatBtn.isHidden = false
            
        case .Used:
            treatStatusImage.isHidden = false
            treatStatusLabel.isHidden = false
            useTreatBtn.isHidden = true
            treatStatusImage.image = TreatStatus.Used.image
            treatStatusLabel.text = TreatStatus.Used.description
            
        case .Delivered:
            treatStatusImage.isHidden = false
            treatStatusLabel.isHidden = false
            useTreatBtn.isHidden = true
            treatStatusImage.image = TreatStatus.Delivered.image
            treatStatusLabel.text = TreatStatus.Delivered.description
            
        case .Expired:
            treatStatusImage.isHidden = false
            treatStatusLabel.isHidden = false
            useTreatBtn.isHidden = true
            treatStatusImage.image = TreatStatus.Expired.image
            treatStatusLabel.text = TreatStatus.Expired.description
            
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }



}
