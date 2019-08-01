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
        
    }
    
    
    
    @IBAction func addFriend(_ sender: UIButton) {
        
        //todo: Show add friend pop up
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
        userImage.image = #imageLiteral(resourceName: "icons8-user")//CurrentUser...image
        nameLabel.text = "\(CurrentUser.shared.get()?.firstName) \(CurrentUser.shared.get()?.lastName)"
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
            
            cell.populate(user: User.init(id: "203137252", email: "shahaf@tepler.com", firstName: "Shahaf", lastName: "Tepler", dateOfBitrh: Date(), friends: [], myCart: [], myTreats: [], myOrders: [], getTreatsStatus: .EVERYONE, address: [:]))
            
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
    
}

extension ProfileViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 7
    }
}
