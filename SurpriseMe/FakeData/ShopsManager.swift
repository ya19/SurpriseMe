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
                        Product.init(id: "#nike1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00),
                        Product.init(id: "#nike2", name: "Nike Custom", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-special"), category: "Shoes",price: 429.00 ),
                        Product.init(id: "#nike3", name: "Air Jodan Retro-7", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-airjodan"), category: "Shoes", price: 1259.00),
                        Product.init(id: "#nike4", name: "Nike Black Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-black"), category: "Shoes", price: 359.00)
                    ]
                    ], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "nike-logo"), backgroudImage: #imageLiteral(resourceName: "nike-background")),
                
                Shop(id: "adidasShop", category: .SPORT, name: "Adidas",
                     products: ["Products" :
                        [
                            Product.init(id: "#adidas1", name: "Adidas Classic", desc: "Elegant classis model of adidas", image: #imageLiteral(resourceName: "adidas-sneakers"), category: "Shoes", price: 359.00),
                            Product.init(id: "#adidas2", name: "Stan Smith", desc: "Stan Smith classic", image: #imageLiteral(resourceName: "adidas-stansmith"), category: "Shoes",price: 529.00 ),
                            Product.init(id: "#adidas3", name: "Adidas Gold", desc: "Amazing shoes", image: #imageLiteral(resourceName: "adidas-shoes1"), category: "Shoes", price: 459.00),
                        ]
                    ],
                     adress: "Malha Mall, Jerusalem", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "adidas-logo"), backgroudImage: #imageLiteral(resourceName: "adidas-background")),
                
                Shop(id: "vertaimer", category: .SPORT, name: "Sports Vertaimer",
                     products:
                    ["Products" :
                        [
                            Product.init(id: "#vertaimer1", name: "Weights Set 20K", desc: "Set of weights with a variety of wieghts to use", image: #imageLiteral(resourceName: "weightsset"), category: "Gym", price: 259.00),
                            Product.init(id: "vertaimer2", name: "Pull Up Bar", desc: "Pull up bar for your wall and door.", image: #imageLiteral(resourceName: "pullupbar"), category: "Gym",price: 529.00 ),
                            Product.init(id: "vertaimer3", name: "Spalding Basketball", desc: "Proffesionals basketball very good to train with.", image: #imageLiteral(resourceName: "basketball"), category: "Games", price: 159.00),
                            
                            Product.init(id: "vertaimer4", name: "Adidas Football", desc: "Proffesionals football very good to train with.", image: #imageLiteral(resourceName: "soccerball"), category: "Games", price: 159.00),                        ]
                    ], adress: "Azrieli Mall", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "vertaimer-logo"), backgroudImage: #imageLiteral(resourceName: "vertaimer-logo")),
                
                Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "nike-logo"), backgroudImage: #imageLiteral(resourceName: "nike-background")),
                
                Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: nil, backgroudImage: #imageLiteral(resourceName: "logo")),
                
                Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "Instagram_icon"), backgroudImage: #imageLiteral(resourceName: "loginBG")),
                
                ],
            [
                Shop(id: "ivoryShop", category: .ELECRICTY, name: "Ivory", products:     ["Products" :
                    [
                        Product.init(id: "#1", name: "Macbook Pro", desc: "the newest version of the macbook pro, with amazing features", image: #imageLiteral(resourceName: "macbook"), category: "Laptops", price: 11_159.00),
                        Product.init(id: "#2", name: "Lenovo Computer", desc: "Lenovo Computer", image: #imageLiteral(resourceName: "lenovo-computer"), category: "Computers",price: 1259.00 ),
                        Product.init(id: "#3", name: "Dell Computer", desc: "Dell computer", image: #imageLiteral(resourceName: "dell-computer"), category: "Computers", price: 1459.00),
                        
                    ]
                    ], adress: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logo: #imageLiteral(resourceName: "ivory-logo"), backgroudImage: #imageLiteral(resourceName: "computers-background")),
                Shop(id: "ivoryShop", category: .ELECRICTY, name: "Ivory", products: [:], adress: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logo: #imageLiteral(resourceName: "logo"), backgroudImage: #imageLiteral(resourceName: "facebook"))
                
                
            ],
            []
            
        ]

    }
}