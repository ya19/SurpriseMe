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
    
    @IBOutlet weak var friendsRequestsTableView: UITableView!
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        //todo reload table data.
        friendsRequestsTableView.reloadData()
    }
    
    var toggle = true
    
    
    @IBAction func addFriend(_ sender: UIButton) {
        
        //todo: Show add friend pop up
        let usersVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController
        
        usersVC.delegate = self
        usersVC.users = UsersManager.shared.getAllButFriends(user: CurrentUser.shared.get()!)
        //            userAddedDelegate = usersVC
        //            userAddedDelegate?.reloadMydata()
        
        
        if menu.toggle {
            toggle = true
        }
        toggle = PopUp.toggle(child: usersVC, parent: self,toggle: toggle)
    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        
        //todo: Show pop up for editing details
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsRequestsTableView.delegate = self
        friendsRequestsTableView.dataSource = self
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    func setupViews(){
        userImage.image = #imageLiteral(resourceName: "icons8-user").circleMasked//CurrentUser...image
        nameLabel.text = "\(CurrentUser.shared.get()!.fullName)"
    }
    
    func deleteFriend(indexPath:IndexPath){
        //            self.products.remove(at: indexPath.row)
        //            CartManager.shared.treats.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //            self.total.text = "Total: \(self.sum) NIS"
        UsersManager.shared.removeFriend(at: indexPath.row)
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
            case 1: return 1 //todo: currentuser.myFriendRequests.
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(friendsRequestsSegmented.selectedSegmentIndex){
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as? NewFriendTableCell else{return UITableViewCell()}
            
//            cell.populate(user: User.init(id: "203137252", email: "shahaf@tepler.com", firstName: "Shahaf", lastName: "Tepler", dateOfBitrh: Date(), friends: [], myCart: [], myTreats: [], myOrders: [], getTreatsStatus: .EVERYONE, address: [:]))
            
            
            cell.populate(user: friends[indexPath.row])
            //todo: populate with actual friends and not fake. at the moment its only ID's.    cell.populate(CurrentUser.shared.get().friends[indexPath.row])
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendRequestCell") as? FriendRequestTableViewCell else{return UITableViewCell()}
            //todo add the populate parameter as request.
            cell.populate()
            
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
        UsersManager.shared.add(friend: userId)
        self.friendsRequestsTableView.reloadData()
    }
}