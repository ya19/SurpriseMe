//
//  Order.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import Foundation

struct Order{
    let id:String
    let treats:[Treat]
    var price:Double{
        var count = 0.0
        for treat in treats{
            count += treat.product.price
        }
        return count
    }
    let date:Date
    let buyer:User?
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
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["id"] = id
        var myTreats:[String:[String:Any]] = [:]
        for treat in treats{
            myTreats[treat.id] = treat.toDB
        }
        dic["treats"] = myTreats
        dic["date"] = dateString
        dic["buyer"] = buyer?.toDB
        dic["price"] = price
        return dic
    }
}
