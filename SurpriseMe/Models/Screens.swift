//
//  Screens.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 18/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

enum Screens:Int,CustomStringConvertible ,CaseIterable{
    case Main = 0 , MyFriends, OrdersAndTreats, Logout
    
    var description: String{
        switch self {
        case .Main:
            return "Main"
        case .MyFriends:
            return "Friends"
        case .OrdersAndTreats:
            return "Orders & Treats"
        case .Logout:
            return "Logout"
        }
    }
    
    var rawVaule:Int{
        switch self {
        case .Main , .MyFriends , .OrdersAndTreats , .Logout:
            return rawValue
        }
    }
}
