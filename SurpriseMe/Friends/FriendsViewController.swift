//
//  FriendsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 18/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    var friends:[User] = [] // init when entering.
//    var userAddedDelegate: UserAddedDelegate?
    
    @IBOutlet weak var table: UITableView!
    //to do: get the friends from Usermanager singelton
    var toggle:Bool = true
    var users:[User] = []
    var delegate : deliverUserDelegate?
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    
    @IBAction func addFriendPopUp(_ sender: UIBarButtonItem) {

            let usersVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController

//            usersVC.delegate = self
            usersVC.users = UsersManager.shared.getAllButFriends(user: CurrentUser.shared.get()!)
//            userAddedDelegate = usersVC
//            userAddedDelegate?.reloadMydata()

        
        if menu.toggle {
            toggle = true
        }
        toggle = PopUp.toggle(child: usersVC, parent: self,toggle: toggle)


    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
//        AppMenu.clearMenu()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    func getUsersData(){
        users = UsersManager.shared.getUsers()
    }
    
    func deleteFriend(indexPath:IndexPath){
        //            self.products.remove(at: indexPath.row)
        //            CartManager.shared.treats.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //            self.total.text = "Total: \(self.sum) NIS"
        UsersManager.shared.removeFriend(friendId: friends[indexPath.row].id)
        friends.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath],with: .fade)
        table.reloadData()
    }
    func showDialog(dialogMessage:UIAlertController){
        self.present(dialogMessage, animated: true, completion: nil)

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

extension FriendsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in

            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete \(self.friends[indexPath.row].fullName)", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                self.deleteFriend(indexPath: indexPath)
            })
            
            // Create Cancel button with action handlder
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
//                print("Cancel button tapped")
            }
            
            //Add OK and Cancel button to dialog message
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            
            // Present dialog message to user
            self.showDialog(dialogMessage: dialogMessage)
        }
        
        removeAction.backgroundColor = UIColor.red
        
        return [removeAction]
    }

}

extension FriendsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FriendTableCell
        cell.populate(user: friends[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 15
    }
    
    
}

//extension FriendsViewController : deliverUserDelegate{
//    func deliver(userId: String) {
//
//        //update in database
////        currentUser.friends.append(user)
////        UsersManager.shared.add(friendRequest: userId)
////        self.friendsTableView.reloadData()
//    }
//}

