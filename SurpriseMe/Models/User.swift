//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
var currentUser = User.init(id: "user1", email: "shahaf_t@narkis.co.il", firstName: "David", lastName: "Tikva", dateOfBitrh: Date(),
          
          friends: [
            User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil)
            
    ],
          myTreats:
    [
        Treat.init(id: "treat1", date: Date(), product: Product.init(id: "product1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 159.00), giver:  User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil), getter:  User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil), treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "treat2", date: Date(), product: Product.init(id: "product2", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 165.00), giver:  User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil), getter:  User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil), treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "treat3", date: Date(), product: Product.init(id: "product3", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 121.00), giver:  User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil), getter:  User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil), treatStatus: TreatStatus.NotUsed)
        
        
    ],
          myOrders:[], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil)
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
    
    let firstName:String
    
    let lastName:String

    var fullName:String{
        return "\(firstName) \(lastName)"
    }
    let dateOfBitrh:Date
    
    var dateString:String{
        return "\(dateOfBitrh)"
    }
    
    var friends:[User]
    
    var myTreats:[Treat]
    
    var myOrders:[Order]
    
    var getTreatsStatus:GetTreatStatus
    
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
        dic["dateOfBirth"] = dateString
        
        //friends
        if friends.count > 0 {
            var myFriends:[String:[String:Any]] = [:]
            for friend in friends{
                myFriends[friend.id] = friend.toDB
            }
            dic["friends"] = myFriends
        }else{
            dic["friends"] = friends
        }
        
        //myTreats
        if myTreats.count > 0{
            var treats:[String:[String:Any]] = [:]
            for treat in myTreats{
                treats[treat.id] = treat.toDB
            }
            dic["myTreats"] = treats
        }else{
            dic["myTreats"] = myTreats
        }
        //myOrders
        if myOrders.count>0{
            var orders:[String:[String:Any]] = [:]
            for order in myOrders{
                orders[order.id] = order.toDB
            }
            dic["myOrders"] = orders
        }else{
            dic["myOrders"] = myOrders
        }
        
        dic["getTreatStatus"] = getTreatsStatus.rawValue
        dic["address"] = address
        
        
        return dic
    }
    //user can have nil/empty array at friends, treats, myOrders , adress.

    static func getUserFromDictionary(_ dic: [String:Any]) -> User{
      
        
        let id = dic["id"] as! String
        let email = dic["email"] as! String
        let firstName = dic["firstName"] as! String
        let lastName = dic["lastName"] as! String
        let dateOfBirth = Date()
        var friends:[User] = []
        if let friendsDic = dic["friends"] as? [String:Any]{
            for key in friendsDic.keys{
                friends.append(User.getUserFromDictionary(friendsDic[key]! as! [String:Any]))
            }
        }
        
        var myTreats:[Treat] = []
        if let treatsDic = dic["myTreats"] as? [String:Any]{
            for key in treatsDic.keys{
                myTreats.append(Treat.getTreatFromDictionary(treatsDic[key]! as! [String:Any]))
            }
        }
        
        var myOrders:[Order] = []
        if let ordersDic = dic["myOrders"] as? [String:Any]{
            for key in ordersDic.keys{
                myOrders.append(Order.getOrderFromDictionary(ordersDic[key]! as! [String:Any]))
            }
        }
        
        let getTreatStatus = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)
        var address:[String:String]? = nil
        if let addressDic = dic["address"] as? [String:String]{
            address = addressDic
        }
        
        return User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus!, address: address)
    }
}
