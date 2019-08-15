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
    var senders:[String:User]?
    override func viewDidLoad() {
        super.viewDidLoad()
        AppMenu.clearMenu()

        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
    }

}

extension NotificationsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return notifications?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationsTableCell
        cell.populate(notification: notifications?[indexPath.row],senderName: senders![notifications![indexPath.row].id!]!.fullName,senderImage: senders![notifications![indexPath.row].id!]!.image!)
        return cell
    }
}

extension NotificationsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 8
    }
}


protocol RefreshNotifications {
    func refresh(notifications: [Notification],senders:[String:User])
}
extension NotificationsViewController:RefreshNotifications{
    func refresh(notifications: [Notification],senders: [String:User]) {
        self.notifications = notifications
        self.senders = senders
        if notificationsTableView != nil{
            notificationsTableView.reloadData()
        }
    }
}
