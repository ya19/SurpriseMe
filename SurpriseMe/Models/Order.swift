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
    let buyer:User
    
}
