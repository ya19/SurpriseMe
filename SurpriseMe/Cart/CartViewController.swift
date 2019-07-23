//
//  CartViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 12/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
//    var products:[Product] = [Product(id: "1", name: "Shoes-x5", desc: "Sport shoes , flexible and effective for running", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 100.0),Product(id: "1", name: "Shoes-x5", desc: "Sport shoes , flexible and effective for running", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 100.0)]
//    var products:[Product] = CartManager.shared.products
    var sum:Double{
        var count = 0.0
        for item in CartManager.shared.treats{
            count += item.product.price
        }
        return count
    }
    var users:[User] = []
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    
    
    
    @IBAction func buy(_ sender: SAButton) {
        
        var filled = true
        for treat in CartManager.shared.treats{
            if treat.getter == nil {
                filled = false
            }
        }
        //create new order , add it to current user orders array
        //create a treat for each tread in the order, add it to the "getter" treats array
        // figure out how to create specific id for each order / treat
        
        if filled {
        let order = Order(id: "#", treats: CartManager.shared.treats, date: Date(), buyer: currentUser)
        currentUser.myOrders.append(order)
        
        for treat in CartManager.shared.treats{
            var updatedTreat = treat
            updatedTreat.date = Date()
            UsersManager.shared.add(treat: updatedTreat, to: treat.getter!)
        }
            CartManager.shared.treats = []
            cartTableView.reloadData()
            total.text = String(sum)
            print(currentUser)
            print(UsersManager.shared.getUsers())
        Toast.show(message: "Order completed", controller: self)
        let ordersAndTreatsVC = UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersAndTreatsViewController
        self.navigationController?.pushViewController(ordersAndTreatsVC, animated: true)
        }else{
            Toast.show(message: "Getters arent filled", controller: self)
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppMenu.clearMenu()
        users = dataFromServer()
        cartTableView.delegate = self
        cartTableView.dataSource = self
//        fakeProducts()
        print(CartManager.shared.treats)
        total.text = "Total: \(sum) NIS"
        
        
        // Do any additional setup after loading the view.
    }
    func dataFromServer() -> [User]{
        return UsersManager.shared.getAllBut(user: currentUser)
    }
//    func fakeProducts(){
//
//        let fakeProduct = Product(id: "1", name: "Shoes-x5", desc: "Sport shoes , flexible and effective for running", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 100.0)
//
//        for _ in 0...4{
//            products.append(fakeProduct)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
            CartManager.shared.treats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.total.text = "Total: \(self.sum) NIS"
        }
        
        removeAction.backgroundColor = UIColor.red
        
        return [removeAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = CartManager.shared.treats[indexPath.row].product
        
        PopUp.toggle(child: itemVC, parent: self,toggle: true)
    }
}
extension CartViewController:UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.treats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartProductTableViewCell
        
        
        cell.populate(treat: CartManager.shared.treats[indexPath.row])
        cell.treat = CartManager.shared.treats[indexPath.row]
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
        
        PopUp.toggle(child: usersVC, parent: self,toggle: true)
    }
    
    
}
protocol AddUserDelegate{
    func addUserTapped(cell:UITableViewCell)
}
