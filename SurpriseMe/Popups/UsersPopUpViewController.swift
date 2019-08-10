//
//  UsersPopUpViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 16/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class UsersPopUpViewController: UIViewController {

    @IBOutlet weak var popUpView: SAView!
    @IBOutlet weak var closeButton: SAButton!
    
    @IBAction func closePopUp(_ sender: SAButton) {
        if let profileVC = self.parent as? ProfileViewController{
            profileVC.toggle = !profileVC.toggle
        }

        PopUp.remove(controller: self)
        
    }
    
    var users:[User]?
    
    var delegate:deliverUserDelegate?
    var currentUsers:[User]?
    
    var searchingFriends:Bool?
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppMenu.clearMenu()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        searchBar.delegate = self
        currentUsers = users
        // Do any additional setup after loading the view.
        
        searchBar.frame = CGRect(origin: CGPoint(x: 1, y: 0.1), size: CGSize(width: (table.frame.width * 0.8), height: (table.frame.height * 0.1)))
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
extension UsersPopUpViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentUsers = users
            table.reloadData()
            return
        }
        currentUsers = users!.filter({ user -> Bool in
            return user.fullName.lowercased().contains(searchText.lowercased())
        })
        table.reloadData()
    }
}
extension UsersPopUpViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        if let friendsVC = self.parent as? FriendsViewController{
//            //update in data base.
//
//            friendsVC.toggle = !friendsVC.toggle
//            delegate?.deliver(userId: self.users![indexPath.row].id)
//
//        }else{
            if let _ = self.parent as? ProfileViewController{
//                profileVC.toggle = !profileVC.toggle
            }else{
            delegate!.deliver(user: self.currentUsers![indexPath.row])
//        }
        PopUp.remove(controller: self)
        }
    }
}
extension UsersPopUpViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserPopUpCell
        if let _ = self.parent as? ProfileViewController{
            var friendAdd = false
            for sent in CurrentUser.shared.get()!.sentFriendRequests{
                if sent == currentUsers![indexPath.row].id{
                    friendAdd = true
                }
            }
            cell.populate(user: currentUsers![indexPath.row], friendAdd: friendAdd)
        }else{
        cell.populate(user: currentUsers![indexPath.row])
        }
        return cell
    }
    
    
}
protocol RefreshNotFriendsVC {
    func reloadMyData(users:[User])
}
extension UsersPopUpViewController:RefreshNotFriendsVC{
    func reloadMyData(users: [User]) {
        self.users = users
        self.currentUsers = users
        self.table.reloadData()
    }
}

//protocol UserAddedDelegate {
//    func reloadMydata()
//}
//extension UsersPopUpViewController:UserAddedDelegate{
//    func reloadMydata() {
//        if self.table != nil {
//            self.table.reloadData()
//        }
//    }
//}
