//
//  CategoryCollectionViewCell.swift
//  SurpriseMe
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var shopsCollectionView: UICollectionView!
    
    
    var shopsData:[Shop] = []

    var delegate: TappedDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopsCollectionView.delegate = self
        shopsCollectionView.dataSource = self
        
        
    }
    
    func populate(shopsArray: [Shop]){
        shopsData = shopsArray
    }
    
}

extension CategoryCollectionViewCell : UICollectionViewDelegate{
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.doIt(shop: shopsData[indexPath.item])
        
    }
    
    
    
}

extension CategoryCollectionViewCell : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return shops[section].count
        return shopsData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! ShopCollectionViewCell
        
//        cell.shopLogo.image = shopsData[indexPath.item].logo
        
        cell.populate(image: shopsData[indexPath.item].logo ?? #imageLiteral(resourceName: "placeholder"))
        
        return cell
    }
    
    
}


extension CategoryCollectionViewCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let windowFrame = UIApplication.shared.keyWindow?.frame
//        let screen = UIScreen.main.bounds
        
        return CGSize(width: collectionView.frame.width * 0.3, height: collectionView.frame.height)
//        return CGSize(width: UIScreen.main.bounds.width * 0.2, height: collectionView.frame.height)

    }
    
//    don't need it but its a good method to work on insets from code. (inside the cell)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
}



var shops = [
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



protocol TappedDelegate {
    func doIt(shop:Shop)
}
