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
        dic["category"] = category.rawValue
        dic["name"] = name
        //products
        
        if  products.count > 0{
        var myProducts:[String:[String:Any]] = [:]
        for product in products["Products"]!{
            myProducts[product.id] = product.toDB
//            print(product.id)
        }
        dic["products"] = myProducts
        } else {
    dic["products"] = products
    }
        //        dic["products"] = products["products"]
        dic["address"] = address
        dic["desc"] = desc
        dic["logoImageName"] = logoImageName
        dic["backgroundImageName"] = backgroundImageName
        return dic
    }
    
    static func getShopFromDictionary(_ dic: [String:Any]) -> Shop{
        let id = dic["id"] as! String
        
        
        let categoryRaw = dic["category"] as! Int
        
        let category = Category(rawValue: categoryRaw)
        
        let name = dic["name"] as! String
        //                print("this is products........---->>>\(dic["products"])")
        var products:[String:[Product]] = [:]
        if dic["products"] != nil {
            let productsDic = dic["products"] as! [String:[String:Any]]
            
            //                print("dgbkenrlgjremgmrejhe$###############################")
            
            var productsArray:[Product] = []
            
            
            for key in productsDic.keys{
                let product = Product.getProductFromDictionary(productsDic[key]!)
                productsArray.append(product)
            }
            let array = productsArray.sorted { (p1, p2) -> Bool in
                return p1.price < p2.price
            }
            products["products"] = array
        }
        let address = dic["address"] as! String
        
        let desc = dic["desc"] as! String
        let logoImageName = dic["logoImageName"] as? String ?? nil
        let backgroundImageName = dic["backgroundImageName"] as? String ?? nil
        
        return Shop.init(id: id, category: category!, name: name, products: products, address: address, desc: desc, logoImageName: logoImageName, backgroundImageName: backgroundImageName)
    }
}

// products -> category name -> poduct id -> product
//generic with categories
//        if  products.count > 0{
//
//            var keyDic:[String:[String:[String:Any]]] = [:]
//            for key in products.keys{
//                var productsDic:[String:[String:Any]] = [:]
//                if products[key]!.count > 0{
//                    for product in products[key]!{
//                        productsDic[product.id] = product.toDB
//                    }
//                    keyDic[key] = productsDic
//                }
//            }
//            dic["products"] = keyDic
//        } else {
//            dic["products"] = products["products"]
//        }
