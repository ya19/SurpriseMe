//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

//var currentUser = User.init(id: "user1", email: "shahaf_t@narkis.co.il", firstName: "David", lastName: "Tikva", dateOfBitrh: Date(),
//          
//          friends: [
//            "user2"
//            
//    ], myCart: [], sentFriendRequests: [], receivedFriendRequests: [],
//          myTreats:
//    [
//        Treat.init(id: "treat1", date: Date(), orderId: nil, product: Product.init(id: "product1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 159.00), giver: "user1", getter: "user2", treatStatus: TreatStatus.Pending),
//        
//        Treat.init(id: "treat1", date: Date(), orderId: nil, product: Product.init(id: "product1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 159.00), giver: "user1", getter: "user2", treatStatus: TreatStatus.Pending),
//        
//        Treat.init(id: "treat1", date: Date(), orderId: nil, product: Product.init(id: "product1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 159.00), giver: "user1", getter: "user2", treatStatus: TreatStatus.Pending)
//        
//    ],
//          myOrders:[], getTreatsStatus: GetTreatStatus.EVERYONE, notifications: [], address: nil)
//consider using cartmanager object or to use mycart from the user. cartmanager will display ui cart only and will not save it in any data, while if u have myCart in the user u can save it and update the current user's cart. well you can also use coredata to store the current cart data there and to use it only from the users device without storing cart data in our DB , well i think thats the best option instead of updating anymoment the cart in the server.
// using CartManager means to delete myCart attribute from user,
// using myCart attribute on current user means to delete CartManager object.
struct User:Hashable,Equatable{
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
//            && lhs.email == rhs.email && lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName
//                lhs.dateOfBitrh == rhs.dateOfBitrh && lhs.friends == rhs.friends
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
//        let dateOfBirth = Date()

        
        let getTreatStatus = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)
        let address:[String:String]? = nil
//        if let addressDic = dic["address"] as? [String:String]{
//            address = addressDic
//        }
        
        return User(id: id, email: email, image: nil, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: [], myCart: [], sentFriendRequests: [], receivedFriendRequests: [], myTreats: [], myOrders: [], getTreatsStatus: getTreatStatus!, notifications: [], address: address)
    }
}
