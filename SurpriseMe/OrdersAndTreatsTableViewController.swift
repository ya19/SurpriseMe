//
//  OrdersAndTreatsTableViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

var user = User.init(id: "203137252", email: "shahaftepler@gmail.com", firstName: "Shahaf", lastName: "Tepler", dateOfBitrh: "16.11.91", friends: [], myTreats:
    [
        Treat.init(id: "#1", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 159.00), giver: nil, getter: nil),
        
        Treat.init(id: "#2", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 165.00), giver: nil, getter: nil),
        
        Treat.init(id: "#3", date: nil, product: Product.init(id: "#1", name: "Nike Green Shoes", desc: "Running shoes with good quality", image: #imageLiteral(resourceName: "nike-shoes"), category: "Shoes", price: 121.00), giver: nil, getter: nil)
    
    
    ], myOrders: [],myCart: [], treatsStatus: .EVERYONE)


class OrdersAndTreatsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "My Treats and Orders"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.myTreats.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "treatCell", for: indexPath) as? TreatCell else{return UITableViewCell()}
        
        cell.populate(treat: user.myTreats[indexPath.row])
        cell.delegate = self
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol UseTreatDelegate{
    //send treat so you can know if the date was expired or not.
    func useTreat(treat: Treat)
}

extension OrdersAndTreatsTableViewController : UseTreatDelegate{
    func useTreat(treat: Treat) {
//        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "registerPopUp") as? RegisterViewController else {return}
//
////        controller.shop = shop
//        self.navigationController?.pushViewController(controller, animated: true)
//        //        self.navigation?.pushViewController(controller, animated: true)
        
        PopUp.show(storyBoardName: "OrdersManagement", vcIdentifer: "useTreatController", parent: self)

    }
}
