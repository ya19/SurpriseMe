//
//  FriendsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 18/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController {
    
    
    //to do: get the friends from Usermanager singelton
    var friends = shahafuser.friends
    var users:[User] = []


    @IBOutlet weak var friendsTableView: UITableView!
    
    
    @IBAction func addFriendPopUp(_ sender: UIBarButtonItem) {
        let usersVC = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController
        
        
        //todo : Get users from database
        usersVC.users = self.users
        
        //todo: making the table view as the delegate
//        if let treatCell = cell as? CartProductTableViewCell{
//            usersVC.delegate = treatCell
//        }
        //        usersVC.delegate =
        
        PopUp.show(child: usersVC, parent: self)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fakeData()
        
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    func fakeData(){
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "yarden" ,lastName: "swissa" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE))
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE))
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "shahaf" ,lastName: "tepler" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE))
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "yair" ,lastName: "frid" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE))
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "iam" ,lastName: "someone" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE))
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "daniel" ,lastName: "daniel" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , treatsStatus: TreatStatus.EVERYONE))
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

