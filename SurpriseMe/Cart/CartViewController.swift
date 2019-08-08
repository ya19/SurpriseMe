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
    var sum:Double{
        var count = 0.0
        for item in CurrentUser.shared.get()!.myCart{
            count += item.product.price
        }
        return count
    }
    var users:[User] = []
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
        //create new order , add it to current user orders array
        //create a treat for each tread in the order, add it to the "getter" treats array
        // figure out how to create specific id for each order / treat
        
        if filled {
//        let order = Order(id: "order\(CurrentUser.shared!.myOrders.count + 1)", treats: CartManager.shared.treats, date: Date(), buyer: CurrentUser.shared)
            //updating current
//            UsersManager.shared.add(order: order)
        
//        for treat in CartManager.shared.treats{
//            var updatedTreat = treat
//            updatedTreat.date = Date()
//            UsersManager.shared.addd()
//        }
            UsersManager.shared.giveTreats(delegate: self)
//            CartManager.shared.treats = []
            total.text = String(sum)
            Toast.show(message: "Order completed", controller: self)
        let ordersAndTreatsVC = UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersAndTreatsViewController
        self.navigationController?.pushViewController(ordersAndTreatsVC, animated: true)
        }else{
            Toast.show(message: "Getters arent filled", controller: self)
        }
        
        
    }
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
        
        if menu.toggle {
            toggle = true
        }
        toggle = PopUp.toggle(child: notificationsVC, parent: self, toggle: toggle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppMenu.clearMenu()
        users = dataFromServer()
        cartTableView.delegate = self
        cartTableView.dataSource = self
//        fakeProducts()
//        print(CartManager.shared.treats)
        total.text = "Total: \(sum) ₪"
        
        
        // Do any additional setup after loading the view.
    }
    func dataFromServer() -> [User]{
        return UsersManager.shared.getAllBut(user: CurrentUser.shared.get()!)
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
//            self.products.remove(at: indexPath.row)
            UsersManager.shared.removeFromCart(at: indexPath.row, delegate: self)
//            CartManager.shared.treats.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
    
            self.total.text = "Total: \(self.sum) ₪"
        }
        
        removeAction.backgroundColor = UIColor.red
        
        return [removeAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = CurrentUser.shared.get()!.myCart[indexPath.row].product
        
        let _ = PopUp.toggle(child: itemVC, parent: self,toggle: true)
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
        
        
        cell.populate(treat: CurrentUser.shared.get()!.myCart[indexPath.row])
//        cell.treat = CurrentUser.shared.get()!.myCart[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
}
extension CartViewController:AddUserDelegate{
    func addUserTapped(cell:UITableViewCell) {
        let usersVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController
        
        usersVC.users = self.users
        if let treatCell = cell as? CartProductTableViewCell{
            usersVC.delegate = treatCell
        }
//        usersVC.delegate =
        
        let _ = PopUp.toggle(child: usersVC, parent: self,toggle: true)
    }
    
    
}
protocol AddUserDelegate{
    func addUserTapped(cell:UITableViewCell)
}
protocol updateCartDelegate {
    func update()
}
extension CartViewController:updateCartDelegate{
    func update() {
        cartTableView.reloadData()
    }
}
