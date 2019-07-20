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
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        
    }
    
    var shop:Shop?
    override func viewDidLoad() {
        super.viewDidLoad()

        AppMenu.clearMenu()
        
        self.collectionView.backgroundView = UIImageView(image: shop?.backgroudImage)
        self.collectionView.backgroundView?.alpha = 0.7
        self.navigationController?.navigationBar.isTranslucent = true

        self.title = shop?.name

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false



        // Do any additional setup after loading the view.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return shop?.products["Products"]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
    
        // Configure the cell
        
//        cell.frame = CGSize(width: self.collectionView.frame.width / 3.0, height: <#T##Double#>)
        //if the shop doesn't have products it shoes one empty product.
        
//        let array = Array(testShop.products["Products"]!)
        let array = Array(shop!.products["Products"]!)
        
//        cell.popoulate(productImage: array[indexPath.item].image ?? #imageLiteral(resourceName: "placeholder"), productPrice: array[indexPath.item].price)
        
        cell.populate(product: array[indexPath.item])
//        cell.productLogo.image = array[indexPath.item].image
//        cell.productPrice.text = "\(array[indexPath.item].price) NIS"
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = shop!.products["Products"]![indexPath.row]
        itemVC.addToCart = true
        PopUp.toggle(child: itemVC, parent: self,toggle: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    

}

extension ShopViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.3, height: collectionView.frame.height / 5.0)
    }
}


