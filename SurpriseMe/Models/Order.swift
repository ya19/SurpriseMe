//
//  Order.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import Foundation
import Firebase

struct Order{
    let id:String
    let treats:[String]
//    var price:Double{
//        var count = 0.0
//        for treat in treats{
//            count += treat.product.price
//        }
//        return count
//    }
    var price:Double
    let date:Date
    let buyer:String
    var dateString: String{
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "dd/MM/yyyy"
        // again convert your date to string
        return formatter.string(from: yourDate!)
    }
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["id"] = id
//        var myTreats:[String:[String:Any]] = [:]
//        for treat in treats{
//            myTreats[treat.id] = treat.toDB
//        }
        dic["treats"] = treats
        dic["date"] =  ServerValue.timestamp()
        dic["buyer"] = buyer
        dic["price"] = price
        return dic
    }
    
    static func getOrderFromDictionary(_ dic: [String:Any]) -> Order{
        let id = dic["id"] as! String

//        let treats = dic["treats"] as! [String:[String:Any]]
//        var allTreats:[Treat] = []
//        for key in treats.keys{
//            allTreats.append(Treat.getTreatFromDictionary(treats[key]!))
//        }
        let price = dic["price"] as! Double
        let allTreats = dic["treats"] as! [String]
        let t = dic["date"] as! TimeInterval
        let date = Date(timeIntervalSince1970: t/1000)
        let buyer = dic["buyer"] as! String
       
        
        return Order(id: id, treats: allTreats, price: price, date: date, buyer: buyer)
    }
}
