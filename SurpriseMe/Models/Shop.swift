//
//  Shop.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

struct Shop{
    
    let id:String
    
    let category:Category
    
    let name:String
    
    let products:[String:[Product]]
    
    let address:String
    
    let desc:String
    
    let logoImageName:String?
    var logo:UIImage?{
        if logoImageName != nil{
            return UIImage(named:  logoImageName!)
        }
        return nil
    }
    let backgroundImageName:String?
    
    var backgroudImage:UIImage?{
        if backgroundImageName != nil{
            return UIImage(named:  backgroundImageName!)
        }
        return nil
    }
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["id"] = id
        dic["category"] = category.description
        dic["name"] = name
        //products
        // products -> category name -> poduct id -> product
        if  products.count > 0{
            
            var keyDic:[String:[String:[String:Any]]] = [:]
            for key in products.keys{
                var productsDic:[String:[String:Any]] = [:]
                if products[key]!.count > 0{
                    for product in products[key]!{
                        productsDic[product.id] = product.toDB
                    }
                    keyDic[key] = productsDic
                }
            }
            dic["products"] = keyDic
        } else {
            dic["products"] = products["products"]
        }
        //        dic["products"] = products["products"]
        dic["address"] = address
        dic["desc"] = desc
        dic["logoImageName"] = logoImageName
        dic["backgroundImageName"] = backgroundImageName
        return dic
    }
    
}
