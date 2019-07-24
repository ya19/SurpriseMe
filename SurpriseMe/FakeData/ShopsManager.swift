//
//  ShopsManager.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 21/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ShopsManager{
    
    static let shared = ShopsManager()
    
    
    
    private var shops:[[Shop]]
    
    private init(){
        shops = []
        fakeDate()
    }
    
    func getShops() -> [[Shop]]{
        return shops
    }
    
    
    func fakeDate(){
        
        shops =  [
            [
                Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: ["Products" :
                    [
                        Product.init(id: "nike1", name: "Nike Green Shoes", desc: "Running shoes with good quality", imageName: "nike-shoes", category: "Shoes", price: 159.00),
                        Product.init(id: "nike2", name: "Nike Custom", desc: "Running shoes with good quality", imageName: "nike-orange", category: "Shoes",price: 429.00 ),
                        Product.init(id: "nike3", name: "Air Jodan Retro-7", desc: "Running shoes with good quality", imageName: "nike-airjordan", category: "Shoes", price: 1259.00),
                        Product.init(id: "nike4", name: "Nike Black Shoes", desc: "Running shoes with good quality", imageName: "nike-special", category: "Shoes", price: 359.00)
                    ]
                    ], address: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logoImageName: "nike-logo", backgroundImageName: "nike-background"),
                
                Shop(id: "adidasShop", category: .SPORT, name: "Adidas",
                     products: ["Products" :
                        [
                            Product.init(id: "adidas1", name: "Adidas Classic", desc: "Elegant classis model of adidas", imageName: "adidas-shoes1", category: "Shoes", price: 359.00),
                            Product.init(id: "adidas2", name: "Stan Smith", desc: "Stan Smith classic", imageName: "adidas-sneakers", category: "Shoes",price: 529.00 ),
                            Product.init(id: "adidas3", name: "Adidas Gold", desc: "Amazing shoes", imageName: "adidas-stansmith", category: "Shoes", price: 459.00),
                        ]
                    ],
                     address: "Malha Mall, Jerusalem", desc: "Expensive sports shop with a lot of shoes and shirts", logoImageName: "adidas-logo", backgroundImageName: "adidas-background"),
                
                Shop(id: "vertaimer", category: .SPORT, name: "Sports Vertaimer",
                     products:
                    ["Products" :
                        [
                            Product.init(id: "vertaimer1", name: "Weights Set 20K", desc: "Set of weights with a variety of wieghts to use", imageName: "weightsset", category: "Gym", price: 259.00),
                            Product.init(id: "vertaimer2", name: "Pull Up Bar", desc: "Pull up bar for your wall and door.", imageName: "pullupbar", category: "Gym",price: 529.00 ),
                            Product.init(id: "vertaimer3", name: "Spalding Basketball", desc: "Proffesionals basketball very good to train with.", imageName: "basketball", category: "Games", price: 159.00),
                            
                            Product.init(id: "vertaimer4", name: "Adidas Football", desc: "Proffesionals football very good to train with.", imageName: "soccerball", category: "Games", price: 159.00),                        ]
                    ], address: "Azrieli Mall", desc: "Expensive sports shop with a lot of shoes and shirts", logoImageName: "vertaimer-logo", backgroundImageName: "vertaimer-logo"),
                
                Shop(id: "randomShop", category: .SPORT, name: "Nike", products: [:], address: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logoImageName: "nike-logo", backgroundImageName: "nike-background"),
                
                Shop(id: "randomShop2", category: .SPORT, name: "Nike", products: [:], address: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logoImageName: "Facebook-logo", backgroundImageName: "Facebook-logo"),
                
                Shop(id: "randomShop3", category: .SPORT, name: "Nike", products: [:], address: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logoImageName: "Instagram_icon", backgroundImageName: "Instagram_icon"),
                
                ],
            [
                Shop(id: "ivoryShop", category: .ELECRICTY, name: "Ivory", products:     ["Products" :
                    [
                        Product.init(id: "1", name: "Macbook Pro", desc: "the newest version of the macbook pro, with amazing features", imageName: "macbook", category: "Laptops", price: 11_159.00),
                        Product.init(id: "2", name: "Lenovo Computer", desc: "Lenovo Computer", imageName: "lenovo-computer", category: "Computers",price: 1259.00 ),
                        Product.init(id: "3", name: "Dell Computer", desc: "Dell computer", imageName: "dell-computer", category: "Computers", price: 1459.00),
                        
                    ]
                    ], address: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logoImageName: "ivory-logo", backgroundImageName: "computers-background"),
                Shop(id: "randomShop4", category: .ELECRICTY, name: "Ivory", products: [:], address: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logoImageName: "surprise", backgroundImageName: "logo-1")
                
                
            ],
            []
            
        ]

    }
}
