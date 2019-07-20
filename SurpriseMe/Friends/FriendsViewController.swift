//
//  FriendsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 18/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    var friends:[User]{
        return currentUser.friends
    }
//    var userAddedDelegate: UserAddedDelegate?
    
    //to do: get the friends from Usermanager singelton
    var toggle:Bool = true
    var users:[User] = []
    var delegate : deliverUserDelegate?
    var popUpOn:Bool = false
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    
    @IBAction func addFriendPopUp(_ sender: UIBarButtonItem) {

            let usersVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController

            usersVC.delegate = self
            usersVC.users = UsersManager.shared.getAllButFriends(user: currentUser)
//            userAddedDelegate = usersVC
//            userAddedDelegate?.reloadMydata()
        if children.count != 0{
            for i in 0 ..< children.count{
                if let _ = children[i] as? MenuViewController{
                    toggle = true
                }
            }
        }
        toggle = PopUp.toggle(child: usersVC, parent: self,toggle: toggle)


    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersData()
        AppMenu.clearMenu()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    func getUsersData(){
        users = UsersManager.shared.getUsers()
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

extension FriendsViewController : UITableViewDelegate{}

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

extension FriendsViewController : deliverUserDelegate{
    func deliver(user: User) {
                
        //update in database
        currentUser.friends.append(user)

        self.friendsTableView.reloadData()
    }
}

