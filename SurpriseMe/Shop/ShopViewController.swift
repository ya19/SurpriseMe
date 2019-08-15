//
//  ShopViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 12/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

private let reuseIdentifier = "productCell"


class ShopViewController: UICollectionViewController{
    
    var toggle = true
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)

    }
    @IBAction func showCart(_ sender: Any) {
        VCManager.shared.initCartVC(caller: self)

    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        VCManager.shared.initNotifications(refresh: false, caller: self)
    }
    
    
    var shop:Shop?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    @objc func backSegue(){
        print("------- Suppose to make back segue")
        self.navigationController?.popViewController(animated: true)
    }
    


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shop?.products["products"]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
    
        let array = Array(shop!.products["products"]!)
        
        cell.populate(product: array[indexPath.item])
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.backgroundColor = UIColor.white
        
        let itemVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = shop!.products["products"]![indexPath.row]
        itemVC.addToCart = true
        itemVC.delegateShop = self
        if toggle{
            toggle = PopUp.toggle(child: itemVC, parent: self,toggle: toggle)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)

        cell?.contentView.backgroundColor = cell?.selectedBackgroundView?.backgroundColor

    }
    
    
    func setup(){
        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.addTarget(self, action: #selector(backSegue) )
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        AppMenu.clearMenu()
        
        self.collectionView.backgroundView = UIImageView(image: shop?.backgroudImage)
        self.collectionView.backgroundView?.alpha = 0.7
        
        self.title = shop?.name
    }

   
    

}

extension ShopViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.3, height: collectionView.frame.height / 5.0)
    }
}
protocol ReleaseToggle{
    func releaseToggle()
}
extension ShopViewController:ReleaseToggle{
    func releaseToggle(){
        self.toggle = true
    }
}

