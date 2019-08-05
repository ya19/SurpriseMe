//
//  Threat.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

struct Treat{
    //
    var id:String
    
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
    
    var giver:String?
    
    var getter:String?
    
    var treatStatus: TreatStatus?
    
    var getUpdatedStatus: TreatStatus?{
        
        
        return treatStatus
        //todo change it to date.
//        if dateString == "Now"{
//            return TreatStatus.Expired
//        }
//        else {return treatStatus}
    }
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["id"] = id
        dic["date"] = ServerValue.timestamp()
        dic["product"] = product.toDB
        dic["giver"] = giver
        dic["getter"] = getter
        dic["status"] = treatStatus?.rawValue
        
        //i can assume that on the first purchase of the treat the status will always be pending.
//        dic["status"] = TreatStatus.Pending.rawValue
        
        return dic
    }
    static func getTreatFromDictionary(_ dic:[String:Any]) -> Treat{
        
        let id = dic["id"] as! String
        let t = dic["date"] as! TimeInterval
        let date = Date(timeIntervalSince1970: t/1000)
        let product = Product.getProductFromDictionary(dic["product"] as! [String:Any])
        let giver = dic["giver"] as! String
        var getter:String? = nil
        if let someGetter = dic["getter"] as? String{
            getter = someGetter
        }
        let status = TreatStatus(rawValue: dic["status"] as! Int)
        return Treat(id: id, date: date, product: product, giver: giver, getter: getter, treatStatus: status)
    }
}

enum TreatStatus:Int{
//    case Expired = 0, Delivered , Used , NotUsed , Pending , Declined
    
    case Pending = 0, Accepted , Used, Delivered, Declined
    
    var description:String{
        switch self{

        case .Delivered:
            return "Delivered"
        case .Used:
            return "Used"
            
        case .Pending:
            return "Waiting"
            
        case .Accepted:
            return "Accepted"
            
        case .Declined:
            return "Declined"
    }
    }
    
    var image: UIImage?{
        switch self{
//        case .Expired:
//            return UIImage(named: "icons8-expired")
        case .Delivered:
            return UIImage(named: "icons8-shipped")
        case .Used:
            return UIImage(named: "icons8-checked_2")
            
        case .Accepted:
            return UIImage(named: "icons8-arrow")
        
        case .Pending:
            return UIImage(named: "icons8-expired")
            
        case .Declined:
            return nil
        }
        
        
    }

}
