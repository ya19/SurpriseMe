//
//  UsersPopUpViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 16/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class UsersPopUpViewController: UIViewController {

    var users:[User]?
    
    var delegate:deliverUserDelegate?
    var currentUsers:[User]?
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
        delegate?.deliver(user: self.currentUsers![indexPath.row])
        if let friendsVC = self.parent as? FriendsViewController{
            //update in data base.
            friendsVC.toggle = !friendsVC.toggle

            
        }
        PopUp.remove(controller: self)
        
    }
}
extension UsersPopUpViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserPopUpCell
        
        cell.populate(user: currentUsers![indexPath.row])
        
        return cell
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
