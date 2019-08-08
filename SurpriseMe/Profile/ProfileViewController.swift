//
//  ProfileViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 01/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var friendsRequestsSegmented: UISegmentedControl!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var friends:[User] = []
    var requests:[User] = []
    @IBOutlet weak var friendsRequestsTableView: UITableView!
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        //todo reload table data.
        friendsRequestsTableView.reloadData()
    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        let notificationsVC = UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
        
        if menu.toggle {
            toggle = true
        }
        toggle = PopUp.toggle(child: notificationsVC, parent: self, toggle: toggle)
        
    }
    var toggle = true
    var editScreenToggle = true
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    
    
    
    
    
    
    @IBAction func addFriend(_ sender: UIButton) {
        
        //todo: Show add friend pop up
        UsersManager.shared.initUsersPopUpFromProfile(refresh: false)
    
        
        
//        let usersVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController
//        
//        usersVC.delegate = self
//        usersVC.users = UsersManager.shared.getAllButFriends(user: CurrentUser.shared.get()!)
//        //            userAddedDelegate = usersVC
//        //            userAddedDelegate?.reloadMydata()
//        
//        
//        if menu.toggle {
//            toggle = true
//        }
//        toggle = PopUp.toggle(child: usersVC, parent: self,toggle: toggle)
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        let registerVC = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "registerPopUp") as! RegisterViewController
        registerVC.fromRegisterButton = false
        
        if menu.toggle {
            editScreenToggle = true
        }
        
        editScreenToggle = PopUp.toggle(child: registerVC, parent: self, toggle: editScreenToggle)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsRequestsTableView.delegate = self
        friendsRequestsTableView.dataSource = self
        AppMenu.clearMenu()
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        if var navigationArray = self.navigationController?.viewControllers{
            var remember = -1;
            for i in 0..<navigationArray.count{
                if  let _ = navigationArray[i] as? ProfileViewController{
                    remember = i
                }
            }
            if remember != -1{
                navigationArray.remove(at: remember) // To remove previous UIViewController
                self.navigationController?.viewControllers = navigationArray
            }
        }
        
    }
    
//    func initList(){
//        UsersManager.shared.initFriendsVC(refresh: true)
//    }
    func setupViews(){
        userImage.image = #imageLiteral(resourceName: "icons8-user").circleMasked//CurrentUser...image
        nameLabel.text = "\(CurrentUser.shared.get()!.fullName)"
    }
    
    func deleteFriend(indexPath:IndexPath){
        //            self.products.remove(at: indexPath.row)
        //            CartManager.shared.treats.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //            self.total.text = "Total: \(self.sum) NIS"
        UsersManager.shared.removeFriend(friendId: friends[indexPath.row].id)
        friends.remove(at: indexPath.row)
        friendsRequestsTableView.deleteRows(at: [indexPath],with: .fade)
        friendsRequestsTableView.reloadData()
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

extension ProfileViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch friendsRequestsSegmented.selectedSegmentIndex{
            case 0: return  friends.count
            case 1: return requests.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(friendsRequestsSegmented.selectedSegmentIndex){
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? NewFriendTableCell else{return UITableViewCell()}

            cell.populate(user: friends[indexPath.row])
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell") as? FriendRequestTableViewCell else{return UITableViewCell()}
            //todo add the populate parameter as request.
            cell.populate(user: requests[indexPath.row])
            cell.user = requests[indexPath.row]
            cell.delegate = self
            cell.profileVC = self
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if friendsRequestsSegmented.selectedSegmentIndex == 1{
            return false
        }
        
        return true
    }
    
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if friendsRequestsSegmented.selectedSegmentIndex == 0{
        let removeAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            
            let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to delete \(self.friends[indexPath.row].fullName)?", preferredStyle: .alert)
            
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
        return nil
    }
    
}

extension ProfileViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 8
    }
}

extension ProfileViewController : deliverUserDelegate{
    func deliver(userId: String) {
        
        //update in database
        //        currentUser.friends.append(user)
//        UsersManager.shared.add(friendRequest: userId)
//        self.friendsRequestsTableView.reloadData()
    }
}


protocol updateList {
    func remove(at: Int)
}

extension ProfileViewController:updateList, RefreshProfileVC{
    func remove(at: Int){
        requests.remove(at: at)
        friendsRequestsTableView.deleteRows(at: [IndexPath(row: at, section: 0)], with: .none)
        friendsRequestsTableView.reloadData()
    }

    func reloadMyData(friends: [User] , requests:[User]) {
        self.friends = friends
        self.requests = requests
        self.friendsRequestsTableView.reloadData()
        print(CurrentUser.shared.get()!,"Current User")
        print(friends,"Friends123")
        print(requests,"Requests123")
    }
}
protocol RefreshProfileVC {
    func reloadMyData(friends: [User] , requests:[User])
}

