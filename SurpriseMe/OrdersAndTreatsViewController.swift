//
//  OrdersAndTreatsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit


var shahafuser = User.init(id: "203137252", email: "shahaf_t@narkis.co.il", firstName: "David", lastName: "Tikva", dateOfBitrh: "16.11.91", friends: [], myTreats:
    [
        Treat.init(id: "#1", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00), giver: nil, getter: nil),
        
        Treat.init(id: "#2", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 165.00), giver: nil, getter: nil),
        
        Treat.init(id: "#3", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 121.00), giver: nil, getter: nil)
        
        
    ], myOrders:
    
    [Order.init(id: "#1", treats: [
        
        Treat.init(id: "#1", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00), giver: nil, getter: nil),
                                           
        Treat.init(id: "#2", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 165.00), giver: nil, getter: nil),
                                           
        Treat.init(id: "#3", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 121.00), giver: nil, getter: nil)], date: Date.init(), buyer: user)
    
    
    
        ],myCart: [], treatsStatus: .EVERYONE)

var orders = shahafuser.myOrders
var treats = shahafuser.myTreats


class OrdersAndTreatsViewController: UIViewController {
    
    
    @IBOutlet weak var ordersTreatsSegmented: UISegmentedControl!
    
    
    @IBOutlet weak var ordersTreatsTableView: UITableView!
    
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        ordersTreatsTableView.reloadData()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "My Treats & Orders"
        
        ordersTreatsTableView.delegate = self
        ordersTreatsTableView.dataSource = self

        // Do any additional setup after loading the view.
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

extension OrdersAndTreatsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 7
    }
    
    
}

extension OrdersAndTreatsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(ordersTreatsSegmented.selectedSegmentIndex){
        case 0: return  orders.count
        case 1: return treats.count
        default:
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(ordersTreatsSegmented.selectedSegmentIndex){
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell else{return UITableViewCell()}
            
            
            cell.order = orders[indexPath.row]
            cell.idLabel.text = orders[indexPath.row].id
            //to do: don't forget to make the calculation ahead.
            cell.priceLabel.text = "\(orders[indexPath.row].price)"
            cell.dateLabel.text = "today"
            cell.delegate = self
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "treatCell") as? TreatCell else{return UITableViewCell()}
            cell.populate(treat: treats[indexPath.row])
            cell.delegate = self
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    

}

protocol ShowPopUpDelegate{
    //send treat so you can know if the date was expired or not.
    func useTreat(treat: Treat)
    
    func showTreats(order: Order)
}

extension OrdersAndTreatsViewController : ShowPopUpDelegate{

    
    func useTreat(treat: Treat) {
        //        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "registerPopUp") as? RegisterViewController else {return}
        //
        ////        controller.shop = shop
        //        self.navigationController?.pushViewController(controller, animated: true)
        //        //        self.navigation?.pushViewController(controller, animated: true)
        
        PopUp.show(storyBoardName: "OrdersManagement", vcIdentifer: "useTreatController", parent: self)
        
    }
    
    func showTreats(order: Order){
        let orderedTreatsVC = UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orderedTreatsController") as! OrderedTreatsViewController
        orderedTreatsVC.treats = order.treats
        PopUp.show(child: orderedTreatsVC, parent: self)
    }

}
