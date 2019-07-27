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
            return UIImage(named:  imageName)
        }
        return nil
    }
    let imageName:String
    let category:String
    let price:Double
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["id"] = id
        dic["name"] = name
        dic["desc"] = desc
        dic["imageName"] = imageName
        dic["category"] = category
        dic["price"] = price
        
        return dic
    }
    
    static func getProductFromDictionary(_ dic: [String:Any])-> Product{
        
        let productId = dic["id"] as! String
        let productName = dic["name"] as! String
        let productDesc = dic["desc"] as! String
        let productImageName = dic["imageName"] as! String
        let productCategory = dic["category"] as! String
        let productPrice = dic["price"] as! Double
        
        
        
        return Product.init(id: productId, name: productName, desc: productDesc, imageName: productImageName, category: productCategory, price: productPrice)
    }
    
}

