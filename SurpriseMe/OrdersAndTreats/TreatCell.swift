//
//  TreatCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class TreatCell: UITableViewCell {

    @IBOutlet weak var acceptTreatBtn: UIButton!
    @IBOutlet weak var declineTreatBtn: UIButton!
    
    @IBOutlet weak var treatImage: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var giver: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    var statusDelegate : TreatStatusChangedDelegate?
    var delegate:ShowPopUpDelegate?
    var treat:Treat?
    
    @IBOutlet weak var treatStatusImage: UIImageView!
    
    @IBOutlet weak var treatStatusLabel: UILabel!
    
    @IBOutlet weak var useTreatBtn: UIButton!
    
    @IBAction func acceptedTreat(_ sender: UIButton) {

        TreatManager.shared.acceptTreat(treat: self.treat , fromNotification: false)
        
        // delegate to reload data.
        statusDelegate?.updateStatus(treatID: self.treat!.id,status: .Accepted)

    }
    
    @IBAction func declinedTreat(_ sender: UIButton) {
        
        TreatManager.shared.declineTreat(treat: treat , fromNotification: false)
        
        // delegate to reload data.
//        statusDelegate?.updateStatus()
        
    }
    
    
    @IBAction func useCoupon(_ sender: UIButton) {
        
        delegate?.useTreat(treat: treat!)
    }
    
    func populate(treat: Treat, giver:String){
        self.treat = treat
        treatImage.image = treat.product.image
        productName.text = treat.product.name
        self.giver.text = "From: \(giver)"
        dateLabel.text = treat.dateString
        
        switch treat.getUpdatedStatus!{
        case .Accepted:
           
           acceptTreatBtn.isHidden = true
           declineTreatBtn.isHidden = true
           treatStatusImage.isHidden = true
            treatStatusLabel.isHidden = true
            useTreatBtn.isHidden = false
            
        case .Used:
           
            acceptTreatBtn.isHidden = true
            declineTreatBtn.isHidden = true
            treatStatusImage.isHidden = false
            treatStatusLabel.isHidden = false
            useTreatBtn.isHidden = true
            treatStatusImage.image = TreatStatus.Used.image
            treatStatusLabel.text = TreatStatus.Used.description
            
        case .Delivered:
            
            acceptTreatBtn.isHidden = true
            declineTreatBtn.isHidden = true
            treatStatusImage.isHidden = false
            treatStatusLabel.isHidden = false
            useTreatBtn.isHidden = true
            treatStatusImage.image = TreatStatus.Delivered.image
            treatStatusLabel.text = TreatStatus.Delivered.description
            
//        case .Expired:
//           
//            
//            acceptTreatBtn.isHidden = true
//            
//            declineTreatBtn.isHidden = true
//            treatStatusImage.isHidden = false
//            treatStatusLabel.isHidden = false
//            useTreatBtn.isHidden = true
//            treatStatusImage.image = TreatStatus.Expired.image
//            treatStatusLabel.text = TreatStatus.Expired.description
            
        case .Pending:
            treatStatusImage.isHidden = false
            treatStatusLabel.isHidden = true
            useTreatBtn.isHidden = true
            treatStatusImage.image = TreatStatus.Pending.image
            treatStatusLabel.text = TreatStatus.Pending.description
        
        case .Declined:
            return
            
        
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        
    }



}
