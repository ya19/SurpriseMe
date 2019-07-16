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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        // Do any additional setup after loading the view.
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

extension UsersPopUpViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.deliver(user: self.users![indexPath.row])
        
        self.view.removeFromSuperview()
    }
}
extension UsersPopUpViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserPopUpCell
        
        cell.populate(user: users![indexPath.row])
        
        return cell
    }
    
    
}


