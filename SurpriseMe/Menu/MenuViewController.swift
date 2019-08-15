//
//  MenuViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase


let menu = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
class MenuViewController: UIViewController {
    var toggle = false
    @IBOutlet weak var table: UITableView!
    
    @IBAction func clear(_ sender: UIButton) {
        AppMenu.clearMenu()
    }
    @IBOutlet weak var screenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(screenBtn)
        table.backgroundColor = UIColor(red: 0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.75)
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        //to do set the current presented view controller, and maybe change the way the menu works so it will work fine. cause if you choose friends and then back to the main its still focused on friends.
        table.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
 
    }

}
extension MenuViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.table.frame.height / 4
    }
//    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
//        return IndexPath(row: checkFocusedCell(), section: 0)
//    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
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
                menu.removeFromParent()

                return
            }
        case Screens.MyProfile:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()

            if let _ = self.parent as? ProfileViewController{
                return
            }else{

                VCManager.shared.initProfileVC()

                return
            }
        case Screens.OrdersAndTreats:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()

            if let _ = self.parent as? OrdersAndTreatsViewController{
                return
            }else{
                VCManager.shared.initMyTreats(refresh: false)
                return
            }
        case .Logout:
            menu.toggle = !menu.toggle
            
            //maybe find a better solution in the try and catch..
            let email = Auth.auth().currentUser?.email
            if Auth.auth().currentUser != nil{
                do {
                    try Auth.auth().signOut()
//                    UsersManager.shared.profileVC = nil
                    clearVCmanagerData()
                    
                    let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "login") as! ViewController
                    Toast.show(message: "\(email!) Logged out successfully", controller: controller)
                    
                    
                    //todo add an alert asking if the user is sure he wants to log out
                    removeDatabaseObservers()
                    
                    self.parent?.navigationController?.pushViewController(controller, animated: true)
                } catch let signOutError as NSError {
                    Toast.show(message: "Error signing out: \(signOutError)", controller: self.parent!)
                }
            }
            self.view.removeFromSuperview()
            return
        }
    }
    
    func clearVCmanagerData(){
        VCManager.shared.profileVC = nil
        VCManager.shared.cartVC = nil
        VCManager.shared.usersPopUP = nil
        VCManager.shared.ordersAndTreatsVC = nil
        VCManager.shared.notificationsVC = nil
        VCManager.shared.notificationsToggle = true
    }
    
    func removeDatabaseObservers(){
        Database.database().reference().child("users").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("friends").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("orders").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("treats").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("myCart").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("sentFriendRequests").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("receivedFriendRequests").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
        Database.database().reference().child("notifications").child(CurrentUser.shared.get()!.id).removeAllObservers()
        
    }
}
extension MenuViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var ary:[Screens] = Screens.AllCass
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        

        let itemTitle = Screens(rawValue: indexPath.row)!.description
        let menuItemsImages = [#imageLiteral(resourceName: "icons8-a_home"),#imageLiteral(resourceName: "icons8-profile"),#imageLiteral(resourceName: "icons8-wish_list") ,#imageLiteral(resourceName: "icons8-logout") ]
        cell.populate(title: itemTitle, image: menuItemsImages[indexPath.row])
        
        return cell
    }
    func checkFocusedCell() -> Int{
        if let _ = self.parent as? CategoriesViewController{
            return Screens.Main.rawVaule
        }else if let _ = self.parent as? ProfileViewController{
            return Screens.MyProfile.rawVaule
        }else if let _ = self.parent as? OrdersAndTreatsViewController{
            return Screens.OrdersAndTreats.rawVaule
        }
        return -1
    }
    

}
