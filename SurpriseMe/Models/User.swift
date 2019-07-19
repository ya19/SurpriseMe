//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
var currentUser = User.init(id: "203137252", email: "shahaf_t@narkis.co.il", firstName: "David", lastName: "Tikva", dateOfBitrh: "16.11.91",
          
          friends: [
            User(id: "2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE),
            
            User.init(id: "10000000", email: "avicohen@gmail.com", firstName: "Avi", lastName: "Cohen", dateOfBitrh: "", friends: [], myTreats: [], myOrders: [], myCart: [], getTreatsStatus: GetTreatStatus.EVERYONE),
            
            User.init(id: "20000000", email: "", firstName: "David", lastName: "Ahomo", dateOfBitrh: "", friends: [], myTreats: [], myOrders: [], myCart: [], getTreatsStatus: GetTreatStatus.EVERYONE)
            
            
    ],
          myTreats:
    [
        Treat.init(id: "#1", date: nil, dateString: "Now", product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "#2", date: nil, dateString: "", product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 165.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "#3", date: nil, dateString: "", product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 121.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed)
        
        
    ],
          
          myOrders:
    [Order.init(id: "#1", treats: [
        
        Treat.init(id: "#1", date: nil, dateString: "", product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "#2", date: nil, dateString: "", product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 165.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed),
        
        Treat.init(id: "#3", date: nil, dateString: "", product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 121.00), giver: nil, getter: nil, treatStatus: TreatStatus.NotUsed)],
        date: Date.init(), buyer: nil)
    ],myCart: [], getTreatsStatus: GetTreatStatus.EVERYONE)
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
    let dateOfBitrh:String
    
    var friends:[User]
    
    var myTreats:[Treat]
    
    var myOrders:[Order]
    
    var myCart:[Product]
    
    var getTreatsStatus:GetTreatStatus

    var hashValue: Int {
        return id.hashValue ^ email.hashValue ^ firstName.hashValue ^ lastName.hashValue
    }
}
