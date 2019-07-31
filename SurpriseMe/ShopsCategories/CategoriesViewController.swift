//
//  CategoriesViewController.swift
//  SurpriseMe
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private let reuseIdentifier = "categoryCell"
private let reuseHeaderIdentifier = "sectionHeader"

class CategoriesViewController: UICollectionViewController {
    
    var handle:AuthStateDidChangeListenerHandle?

    @IBAction func showMenu(_ sender: UIBarButtonItem) {
//        PopUp.show(storyBoardName: "Menu", vcIdentifer: "menuVC", parent: self)
            AppMenu.toggleMenu(parent: self)
    }
    
    var myShops:[[Shop]] = [[]]
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UsersManager.shared.getUsers(),"$$$$$$$$$$$$")
        self.navigationController?.navigationBar.isHidden = false
        AppMenu.clearMenu()
        
        if Auth.auth().currentUser != nil{
            Toast.show(message: "\(Auth.auth().currentUser!.email!) Logged in successfully", controller: self)
        }
        
        
        self.collectionView.backgroundView = UIImageView(image: UIImage.init(named: "shopping-background5"))
        self.collectionView.backgroundView?.alpha = 0.1
        self.navigationController?.navigationBar.isTranslucent = true
        
        myShops = ShopsManager.shared.getShops()
//
//        ShopsManager.shared.delegate = self
//        myShops = ShopsManager.shared.getFakeShops()
        let ref = Database.database().reference()
//        ref.child("users").removeValue()
//        ref.child("user").setValue(currentUser.toDB)
//        ref.child("user").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let dic = DataSnapshot.value as! [String:Any]
//            print("%$#@!\(User.getUserFromDictionary(dic))")
//        }
//                ref.child("treat").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let dic = DataSnapshot.value as! [String:Any]
//            print("%$#@!\(Treat.getTreatFromDictionary(dic))")
//        }
  
        
        
        
//        ref.child("treat").setValue(Treat(id: "treat1", date: Date(), product: Product(id: "product1", name: "basketball", desc: "ball", imageName: "basketball", category: "SomeCategory", price: 10.2), giver: currentUser, getter: currentUser, treatStatus: TreatStatus.Expired).toDB)
////
//        ref.child("Order").setValue(Order(id: "id1", treats: [Treat(id: "treat1", date: nil, product: Product(id: "product1", name: "shoes", desc: "desc", imageName: "name", category: "shoes", price: 15.0), giver: currentUser, getter: currentUser, treatStatus: TreatStatus.NotUsed),Treat(id: "treat2", date: nil, product: Product(id: "product1", name: "shoes", desc: "desc", imageName: "name", category: "shoes", price: 15.0), giver: currentUser, getter: currentUser, treatStatus: TreatStatus.NotUsed),Treat(id: "treat3", date: nil, product: Product(id: "product1", name: "shoes", desc: "desc", imageName: "name", category: "shoes", price: 15.0), giver: currentUser, getter: currentUser, treatStatus: TreatStatus.NotUsed),Treat(id: "treat4", date: nil, product: Product(id: "product1", name: "shoes", desc: "desc", imageName: "name", category: "shoes", price: 15.0), giver: currentUser, getter: currentUser, treatStatus: TreatStatus.NotUsed)], date: Date(), buyer: currentUser).toDB)
//        ref.child("Order").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let dic = DataSnapshot.value as! [String:Any]
//            print("!@#$%\(Order.getOrderFromDictionary(dic))")
//        }
////        ref.child("users").child(currentUser.id).setValue(currentUser.toDB)
//
//        for shopCategory in myShops{
//            for shop in shopCategory{
//            ref.child("shops").child(shop.id).setValue(shop.toDB)
//        }
//        }
////        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            Toast.show(message: "\(Auth.auth().currentUser) logged in successfully", controller: self)
//        }
//    }

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
        // #warning Incomplete implementation, return the number of sections
//        return ShopsManager.shared.getShops().count
        return myShops.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        // Configure the cell
//        cell.categoryLabel.text = categories[indexPath.item]
//        cell.shopsData = shops[indexPath.section]
        
        cell.populate(shopsArray: myShops[indexPath.section])
        //set the delegate
        cell.delegate = self
        cell.shopsCollectionView.reloadData()
        
        return cell
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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! SectionHeader
            // Customize headerView here
            
            headerView.sectionHeaderTitle.text = categories[indexPath.section]
            return headerView
        }
        
        fatalError()
    }

}



let categories = ["Sports","Electricity", "Clothes"]

extension CategoriesViewController: TappedDelegate{
    func doIt(shop:Shop) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "shopController") as? ShopViewController else {return}
        
        controller.shop = shop
        self.navigationController?.pushViewController(controller, animated: true)
//        self.navigation?.pushViewController(controller, animated: true)
    }
}
protocol DoneReadingDBDelegate{
    func dbREAD(shops:[[Shop]])
}

extension CategoriesViewController : DoneReadingDBDelegate{
    func dbREAD(shops:[[Shop]]) {
        myShops = shops
        self.collectionView.reloadData()
    }
    
    
}
