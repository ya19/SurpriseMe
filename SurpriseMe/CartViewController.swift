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
        for item in CartManager.shared.products{
            count += item.price
        }
        return count
    }
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    @IBAction func buy(_ sender: SAButton) {
        Toast.show(message: "go to paypal", controller: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
//        fakeProducts()
        total.text = "Total: \(sum)"
        
        
        // Do any additional setup after loading the view.
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
        let removeAction = UITableViewRowAction(style: .destructive, title: "remove") { (action, indexPath) in
//            self.products.remove(at: indexPath.row)
            CartManager.shared.products.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.total.text = "Total: \(self.sum)"
        }
        
        removeAction.backgroundColor = UIColor.red
        
        return [removeAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemVC = self.storyboard?.instantiateViewController(withIdentifier: "itemPopUp") as! ItemPopUpViewController
        itemVC.item = CartManager.shared.products[indexPath.row]
        
        PopUp.show(child: itemVC, parent: self)
    }
}
extension CartViewController:UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartManager.shared.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartProductTableViewCell
        
        let product = CartManager.shared.products[indexPath.row]
        cell.productImage.image = product.image
        cell.productName.text = product.name
        cell.productPrice.text = "Price: \(product.price)"
        return cell
    }
    
    
}
