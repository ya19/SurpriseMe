//
//  Product.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

struct Product{
    let id:String
    let name:String
    let desc:String
    var image:UIImage?{
        if imageName != nil{
            return UIImage(named:  imageName!)
        }
        return nil
    }
    let imageName:String?
    let category:String
    let price:Double
    
    
}
