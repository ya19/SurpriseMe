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
        
        let windowFrame = UIApplication.shared.keyWindow?.frame
        let screen = UIScreen.main.bounds
        print(windowFrame)
        print(screen)
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
                    Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00),
                    Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes",price: 189.00 ),
                    Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 259.00),
                    Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 359.00)
                ]
                ], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "nike-logo"), backgroudImage: #imageLiteral(resourceName: "nike-background")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "Facebook-logo"), backgroudImage: #imageLiteral(resourceName: "surprise")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "pure-blue-sky"), backgroudImage: #imageLiteral(resourceName: "logo")),
            
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
                    Product.init(id: "#4", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: nil, category: "Shoes", price: 159.00)
                ]
                ], adress: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logo: #imageLiteral(resourceName: "ivory-logo"), backgroudImage: #imageLiteral(resourceName: "facebook")),
            Shop(id: "ivoryShop", category: .ELECRICTY, name: "Ivory", products: [:], adress: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logo: #imageLiteral(resourceName: "logo"), backgroudImage: #imageLiteral(resourceName: "facebook"))
            
            
        ],
        []
        
    ]



protocol TappedDelegate {
    func doIt(shop:Shop)
}
