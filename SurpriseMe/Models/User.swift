//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
var currentUser = User.init(id: "1", email: "shahaf_t@narkis.co.il", firstName: "David", lastName: "Tikva", dateOfBitrh: Date(),
          
          friends: [
            User(id: "2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE, address: nil),
            
    ],
          myTreats:
    [
        Treat.init(id: "#1", date: Date(), product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 159.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "#2", date: Date(), product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 165.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "#3", date: Date(), product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 121.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed)
        
        
    ],
          myOrders:[],myCart: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil)
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
    
    var myCart:[Product]
    
    var getTreatsStatus:GetTreatStatus
    
    var address:[String:String]?
    
    var hashValue: Int {
        return id.hashValue ^ email.hashValue ^ firstName.hashValue ^ lastName.hashValue
    }
}
