//
//  CartViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 12/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    var toggle = true
    var itemToggle = true
    var sum:Double{
        var count = 0.0
        for item in CurrentUser.shared.get()!.myCart{
            count += item.product.price
        }
        return count
    }
//    var users:[User] = []
    var getters:[String:String] = [:]
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    
    
    @IBAction func buy(_ sender: SAButton) {
        
        var filled = true
        for treat in CurrentUser.shared.get()!.myCart{
            if treat.getter == nil {
                filled = false
            }
        }
        if CurrentUser.shared.get()!.myCart.count == 0{
            Toast.show(message: "Your cart is empty", controller: self)
            return
        }

        
        if filled {

            UsersManager.shared.giveTreats(delegate: self)
            total.text = String(sum)
            Toast.show(message: "Order completed", controller: self)
        }else{
            Toast.show(message: "Getters arent filled", controller: self)
        }
        
        
    }
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        VCManager.shared.initNotifications(refresh: false, caller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppMenu.clearMenu()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        total.text = "Total: \(sum) ₪"
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        if var navigationArray = self.navigationController?.viewControllers{
            var remember = -1;
            for i in 0..<navigationArray.count{
                if  let _ = navigationArray[i] as? CartViewController{
                    remember = i
                }
            }
            if remember != -1{
                navigationArray.remove(at: remember) // To remove previous UIViewController
                self.navigationController?.viewControllers = navigationArray
            }
        }
        
    }
    


}
extension CartViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIApplication.shared.keyWindow?.frame.height)!/6.2
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            UsersManager.shared.removeFromCart(at: indexPath.row, delegate: self)

    
            self.total.text = "Total: \(self.sum) ₪"
        }
        
        removeAction.backgroundColor = UIColor.red
        
        return [removeAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = CurrentUser.shared.get()!.myCart[indexPath.row].product
        itemVC.delegateCart = self
        if itemToggle{
            itemToggle = PopUp.toggle(child: itemVC, parent: self,toggle: true)
        }
    }
}
extension CartViewController:UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CurrentUser.shared.get()!.myCart.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartProductTableViewCell
        
        let treat = CurrentUser.shared.get()!.myCart[indexPath.row]
        
        cell.populate(treat: treat,getter: getters[treat.id]!)
        cell.delegate = self
        return cell
    }
    
    
}
extension CartViewController:AddUserDelegate{
    func addUserTapped(cell:UITableViewCell) {

        if let treatCell = cell as? CartProductTableViewCell{
            VCManager.shared.usersPopUP?.delegate = treatCell
            VCManager.shared.initUsersPopUP(refresh: false, withOutFriends: false,parent: self, cellDelegate: nil)

        }
    }
    
    
}
protocol AddUserDelegate{
    func addUserTapped(cell:UITableViewCell)
}
protocol updateCartDelegate {
    func update()
}
protocol ReleaseCartToggle {
    func releaseCartToggle()
}
extension CartViewController:updateCartDelegate, ReleaseCartToggle{
    func update() {
        cartTableView.reloadData()
        total.text = "Total: \(sum) ₪"

    }
    func releaseCartToggle() {
        itemToggle = true
    }
}
