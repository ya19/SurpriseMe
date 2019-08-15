//
//  ShopsManager.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 21/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class ShopsManager{
    
    static let shared = ShopsManager()
    
    let ref = Database.database().reference()
    private var shops:[[Shop]]
    
    private init(){
        shops = []
    }
    
    func update(shops:[[Shop]]) {
        self.shops = shops
    }
    func getShops()-> [[Shop]]{
        return shops
    }
    

    func getFakeShops()-> [[Shop]]{
        return shops
    }
    
}

