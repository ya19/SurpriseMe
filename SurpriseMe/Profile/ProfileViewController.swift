//
//  ProfileViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 01/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBAction func showImagePicker(_ sender: UIButton) {
        didOpenImagePicker = true
        self.imagePicker.present(from: sender)

    }

    @IBOutlet weak var friendsRequestsSegmented: UISegmentedControl!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var friends:[User] = []
    var requests:[User] = []
    var imagePicker: ImagePicker!
    @IBOutlet weak var friendsRequestsTableView: UITableView!
    
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        //todo reload table data.
        friendsRequestsTableView.reloadData()
    }
    
    @IBAction func showNotifications(_ sender: UIBarButtonItem) {
        VCManager.shared.initNotifications(refresh: false, caller: self)
    }
    
    var toggle = true
    var editScreenToggle = true
    var didOpenImagePicker = false
    
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    
    
    @IBAction func showCart(_ sender: Any) {
        VCManager.shared.initCartVC(caller: self)

    }
    
    
    
    
    @IBAction func addFriend(_ sender: UIButton) {

        VCManager.shared.initUsersPopUP(refresh: false, withOutFriends: true,parent: self, cellDelegate: nil)

        

    }
    
    @IBAction func editClicked(_ sender: UIButton) {
        
        self.navigationController?.navigationBar.isHidden = true
        
        let registerVC = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(withIdentifier: "registerPopUp") as! RegisterViewController
        registerVC.fromRegisterButton = false
        
        if menu.toggle {
            editScreenToggle = true
        }
        if editScreenToggle{
            editScreenToggle = PopUp.toggle(child: registerVC, parent: self, toggle: editScreenToggle)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        friendsRequestsTableView.delegate = self
        friendsRequestsTableView.dataSource = self
        AppMenu.clearMenu()
        setupViews()
        self.userImage.image = CurrentUser.shared.get()!.image!.circleMasked
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    override func viewWillDisappear(_ animated: Bool) {
        
        if !didOpenImagePicker{
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
    }

    func setupViews(){
        userImage.image = #imageLiteral(resourceName: "icons8-user").circleMasked//CurrentUser...image
        nameLabel.text = "\(CurrentUser.shared.get()!.fullName)"
    }
    
    func deleteFriend(indexPath:IndexPath){

        UsersManager.shared.removeFriend(friendId: friends[indexPath.row].id)
        friends.remove(at: indexPath.row)
        friendsRequestsTableView.deleteRows(at: [indexPath],with: .fade)
        friendsRequestsTableView.reloadData()
    }
    
    func showDialog(dialogMessage:UIAlertController){
        self.present(dialogMessage, animated: true, completion: nil)
        
    }

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


protocol updateList {
    func remove(at: Int)
}

extension ProfileViewController:updateList, RefreshProfileVC{
    func remove(at: Int){
        requests.remove(at: at)
        friendsRequestsTableView.deleteRows(at: [IndexPath(row: at, section: 0)], with: .none)
        friendsRequestsTableView.reloadData()
    }

    func reloadMyData(friends: [User]? , requests:[User]?) {
        if friends != nil{
            self.friends = friends!
        }
        if requests != nil{
            self.requests = requests!
        }
        if self.friendsRequestsTableView != nil{
            self.friendsRequestsTableView.reloadData()
        }
    }
}
protocol RefreshProfileVC {
    func reloadMyData(friends: [User]? , requests:[User]?)
}


extension ProfileViewController: ImagePickerDelegate {
    
    
    //here you need to update the server.
    func didSelect(image: UIImage?) {
        didOpenImagePicker = false
        if image != nil{
        self.userImage.image = image?.circleMasked
        }
    }
}
