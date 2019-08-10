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
    var toggle = true
    
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
//        PopUp.show(storyBoardName: "Menu", vcIdentifer: "menuVC", parent: self)
            AppMenu.toggleMenu(parent: self)
    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
        
        if menu.toggle {
            toggle = true
        }
        toggle = PopUp.toggle(child: notificationsVC, parent: self, toggle: toggle)
    }
    @IBAction func showCart(_ sender: Any) {
        VCManager.shared.initCartVC(caller: self)
    }
    
    
    var myShops:[[Shop]] = [[]]
    

    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            Toast.show(message: "\(Auth.auth().currentUser!.email!) Logged in successfully", controller: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UsersManager.shared.getUsers(),"$$$$$$$$$$$$")
        AppMenu.clearMenu()
        
        
        
        self.collectionView.backgroundView = UIImageView(image: UIImage.init(named: "shopping-background5"))
        self.collectionView.backgroundView?.alpha = 0.1
        
        myShops = ShopsManager.shared.getShops()

//        let ref = Database.database().reference()
//        setTreatsObserver()

        
        
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
    }
    
    
    //suppose to send notification whenever the user received a treat.
    func setTreatsObserver(){
        Database.database().reference().child("treats").child(CurrentUser.shared.get()!.id).observe(.childAdded) { (datasnapshot) in
            UserNotificationManager.shared.createNotification(with: "Come find out from who!", delay: 0.5, notificationType: .isTreatRequest)
        }
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
