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
    var products:[Product] = []
    var sum:Double = 0
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.delegate = self
        cartTableView.dataSource = self
        fakeProducts()
        total.text = "Total: \(calculateSum())"
        
        
        // Do any additional setup after loading the view.
    }
    
    func fakeProducts(){
        
        let fakeProduct = Product(id: "1", name: "Shoes-x5", desc: "Sport shoes , flexible and effective for running", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 100.0)
        
        for _ in 0...4{
            products.append(fakeProduct)
        }
    }
    
    func calculateSum() -> Double{
        sum = 0
        for item in products{
            sum += item.price
        }
        return sum
    }
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
        return 145
    }
}
extension CartViewController:UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! CartProductTableViewCell
        
        cell.product = products[indexPath.row]
        return cell
    }
    
    
}
