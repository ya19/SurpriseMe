//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

struct User:Hashable,Equatable{
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id

    }
    
    
    let id:String
    
    let email:String
    
    var image:UIImage?
    
    let firstName:String
    
    let lastName:String

    var fullName:String{
        return "\(firstName) \(lastName)"
    }
    let dateOfBitrh:Date
    
    var dateString:String{
        return "\(dateOfBitrh)"
    }
    
    var friends:[String]
    
    var myCart:[Treat]
    
    var sentFriendRequests:[String]
    
    var receivedFriendRequests:[String]
    
    var myTreats:[Treat]
    
    var myOrders:[Order]
    
    var getTreatsStatus:GetTreatStatus
    
    var notifications:[Notification]
    
    var address:[String:String]?
    
    var hashValue: Int {
        return id.hashValue ^ email.hashValue ^ firstName.hashValue ^ lastName.hashValue
    }
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["id"] = id
        dic["email"] = email
        dic["firstName"] = firstName
        dic["lastName"] = lastName
        dic["dateOfBirth"] = dateOfBitrh.timeIntervalSince1970       
        dic["getTreatStatus"] = getTreatsStatus.rawValue
//        dic["address"] = address
        
        
        return dic
    }
    //user can have nil/empty array at friends, treats, myOrders , adress.

    static func getUserFromDictionary(_ dic: [String:Any]) -> User{
      
        
        let id = dic["id"] as! String
        let email = dic["email"] as! String
        let firstName = dic["firstName"] as! String
        let lastName = dic["lastName"] as! String
        let myTimeInterval = TimeInterval(dic["dateOfBirth"] as! Double)
        let dateOfBirth = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))

        
        let getTreatStatus = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)
        let address:[String:String]? = nil
//        if let addressDic = dic["address"] as? [String:String]{
//            address = addressDic
//        }
        
        return User(id: id, email: email, image: nil, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: [], myCart: [], sentFriendRequests: [], receivedFriendRequests: [], myTreats: [], myOrders: [], getTreatsStatus: getTreatStatus!, notifications: [], address: address)
    }
}
