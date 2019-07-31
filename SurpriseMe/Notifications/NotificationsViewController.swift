//
//  NotificationsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 31/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!
    var notifications:[Notification]?

    override func viewDidLoad() {
        super.viewDidLoad()
        AppMenu.clearMenu()
        
        //notifications = ...
        // Do any additional setup after loading the view.
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
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

extension NotificationsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Todo return count of notifications
        return notifications?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationsTableCell
        cell.populate(notification: notifications?[indexPath.row])
        
        return cell
    }
}

extension NotificationsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 10
    }
}
