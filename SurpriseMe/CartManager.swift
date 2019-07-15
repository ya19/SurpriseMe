//
//  CartManager.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CartManager{
    static var shared = CartManager()
    
    var products:[Product]
    
    private init(){
        //TODO init previous cart from database
        products = []
    }
}
