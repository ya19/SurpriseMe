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


protocol TappedDelegate {
    func doIt(shop:Shop)
}
