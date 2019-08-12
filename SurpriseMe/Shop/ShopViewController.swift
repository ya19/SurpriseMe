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
        
//        let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
//
//        if menu.toggle {
//            toggle = true
//        }
//        toggle = PopUp.toggle(child: notificationsVC, parent: self, toggle: toggle)
        VCManager.shared.initNotifications(refresh: false, caller: self)
    }
    
    
    var shop:Shop?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.addTarget(self, action: #selector(backSegue) )
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        AppMenu.clearMenu()
        
        self.collectionView.backgroundView = UIImageView(image: shop?.backgroudImage)
        self.collectionView.backgroundView?.alpha = 0.7

        self.title = shop?.name
      

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false



        // Do any additional setup after loading the view.
    }
    
    @objc func backSegue(){
        print("------- Suppose to make back segue")
        self.navigationController?.popViewController(animated: true)
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
        return shop?.products["products"]?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
    
        // Configure the cell
        
//        cell.frame = CGSize(width: self.collectionView.frame.width / 3.0, height: <#T##Double#>)
        //if the shop doesn't have products it shoes one empty product.
        
//        let array = Array(testShop.products["Products"]!)
        let array = Array(shop!.products["products"]!)
        
//        cell.popoulate(productImage: array[indexPath.item].image ?? #imageLiteral(resourceName: "placeholder"), productPrice: array[indexPath.item].price)
        cell.populate(product: array[indexPath.item])
//        cell.productLogo.image = array[indexPath.item].image
//        cell.productPrice.text = "\(array[indexPath.item].price) NIS"
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = shop!.products["products"]![indexPath.row]
        itemVC.addToCart = true
        itemVC.delegateShop = self
        if toggle{
            toggle = PopUp.toggle(child: itemVC, parent: self,toggle: toggle)
        }
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
protocol ReleaseToggle{
    func releaseToggle()
}
extension ShopViewController:ReleaseToggle{
    func releaseToggle(){
        self.toggle = true
    }
}

