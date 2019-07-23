//
//  Threat.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

struct Treat{
    //
    var id:String?
    
    var date:Date?
    
    var dateString: String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        return formatter.string(from: yourDate!)
    }
    
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
            return "Expired"
        case .Delivered:
            return "Delivered"
        case .Used:
            return "Used"
            
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
