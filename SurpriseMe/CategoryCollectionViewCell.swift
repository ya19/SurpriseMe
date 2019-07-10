//
//  CategoryCollectionViewCell.swift
//  SurpriseMe
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var shopsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        shopsCollectionView.delegate = self
        shopsCollectionView.dataSource = self
    }
    
}

extension CategoryCollectionViewCell : UICollectionViewDelegate{
    
    
    
}

extension CategoryCollectionViewCell : UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shops.count
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops[section].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shopCell", for: indexPath) as! ShopCollectionViewCell
        
        cell.shopLogo.image = shops[indexPath.section][indexPath.item].logo
        
        return cell
    }
    
    
}




var shops = [
        [
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "facebook"), backgroudImage: #imageLiteral(resourceName: "Instagram_icon")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "Facebook-logo"), backgroudImage: #imageLiteral(resourceName: "surprise")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "pure-blue-sky"), backgroudImage: #imageLiteral(resourceName: "logo")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "logo"), backgroudImage: #imageLiteral(resourceName: "Facebook-logo")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "surprise"), backgroudImage: #imageLiteral(resourceName: "logo")),
            
            Shop(id: "nikeShop", category: .SPORT, name: "Nike", products: [:], adress: "Shoam 3 St. Ramat Gan", desc: "Expensive sports shop with a lot of shoes and shirts", logo: #imageLiteral(resourceName: "Instagram_icon"), backgroudImage: #imageLiteral(resourceName: "loginBG")),
            
            ],
        [
            Shop(id: "ivoryShop", category: .ELECRICTY, name: "Ivory", products: [:], adress: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logo: #imageLiteral(resourceName: "Instagram_icon"), backgroudImage: #imageLiteral(resourceName: "facebook")),
            Shop(id: "ivoryShop", category: .ELECRICTY, name: "Ivory", products: [:], adress: "Kenyon Ayalon, Ramat Gan", desc: "Computers shop with a lot of products", logo: #imageLiteral(resourceName: "logo"), backgroudImage: #imageLiteral(resourceName: "facebook"))
            
            
        ]
        
    ]
