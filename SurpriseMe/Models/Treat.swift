//
//  Threat.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

struct Treat{
    
    var id:String?
    
    var date:Date?
    
    var dateString: String?
    
    var product:Product
    
    var giver:User?
    
    var getter:User?
    
    var treatStatus: TreatStatus?
    
    var getUpdatedStatus: TreatStatus?{
        
        //todo change it to date.
        if dateString == "Now"{
            return TreatStatus.Expired
        }
        else {return treatStatus}
    }
}

enum TreatStatus{
    case Expired , Delivered , Used , NotUsed
    
    var description:String{
        switch self{
        case .Expired:
            return "Voucher Expired"
        case .Delivered:
            return "Voucher Delivered"
        case .Used:
            return "Voucher Used"
            
        case .NotUsed:
            return "Not Yet Used"
    }
    }
    
    var image: UIImage?{
        switch self{
        case .Expired:
            return UIImage(named: "icons8-expired")
        case .Delivered:
            return UIImage(named: "icons8-shipped")
        case .Used:
            return UIImage(named: "icons8-checked_2")
            
        case .NotUsed:
            return UIImage(named: "icons8-arrow")
        }
    }
    
}
