//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
let currentUser = User(id: "1", email: "email@gmail.com" ,firstName: "yarden" ,lastName: "swissa" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE)

//consider using cartmanager object or to use mycart from the user. cartmanager will display ui cart only and will not save it in any data, while if u have myCart in the user u can save it and update the current user's cart. well you can also use coredata to store the current cart data there and to use it only from the users device without storing cart data in our DB , well i think thats the best option instead of updating anymoment the cart in the server.
// using CartManager means to delete myCart attribute from user,
// using myCart attribute on current user means to delete CartManager object.
struct User{
    
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
    
    var treatsStatus:TreatStatus
    
}
