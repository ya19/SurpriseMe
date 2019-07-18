//
//  MenuViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
let menu = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
class MenuViewController: UIViewController {
    var toggle = false
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = UIColor(red: 0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1)
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
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
extension MenuViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.table.frame.height / 4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Screens(rawValue: indexPath.row)! {
        case Screens.Main:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()

            if let _ = self.parent as? CategoriesViewController{
                return
            }else{
                let mainVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                self.parent?.navigationController?.pushViewController(mainVC, animated: true)
                return
            }
        case Screens.MyFriends:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()
            if let _ = self.parent as? FriendsViewController{
                return
            }else{
                let friendsVC = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "friends") as! FriendsViewController
                self.parent?.navigationController?.pushViewController(friendsVC, animated: true)
                return
            }
        case Screens.OrdersAndTreats:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()
            if let _ = self.parent as? OrdersAndTreatsViewController{
                return
            }else{
                let ordersAndTreatsVC = UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersAndTreatsViewController
                self.parent?.navigationController?.pushViewController(ordersAndTreatsVC, animated: true)
                return
            }
        case .Logout:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()
            Toast.show(message: "Logout", controller: self.parent!)
            return
        }
    }
}
extension MenuViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var ary:[Screens] = Screens.AllCass
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        
        var itemTitle = Screens(rawValue: indexPath.row)!.description
        if itemTitle == "OrdersAndTreats"{
            itemTitle = "Orders & Treats"
        }
        cell.populate(title: itemTitle)
        
        return cell
    }
    
    
}
