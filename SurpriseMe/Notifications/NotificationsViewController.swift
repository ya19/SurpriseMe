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
//    let notification = Notification.init(date: Date(), imageName: nil, sender: CurrentUser.shared.get()!.id, notificationType: .isFriedRequest)
    var notifications:[Notification]?
    var senders:[String:String]?
    override func viewDidLoad() {
        super.viewDidLoad()
//        notifications = CurrentUser.shared.get()!.notifications
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
        cell.populate(notification: notifications?[indexPath.row],senderName: senders![notifications![indexPath.row].id!]!)
//        cell.delegate = self
        cell.updateListDelegate = self
        return cell
    }
}

extension NotificationsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 8
    }
}


//extension NotificationsViewController : ChangedNotificationStateDelegate{
//    func stateChanged() {
//        
//        notifications = CurrentUser.shared.get()?.notifications
//        self.notificationsTableView.reloadData()
//    }
//}

extension NotificationsViewController : updateList{
    func remove(at: Int) {
        notifications!.remove(at: at)
        notificationsTableView.deleteRows(at: [IndexPath(row: at, section: 0)], with: .none)
        notificationsTableView.reloadData()

    }
}

protocol RefreshNotifications {
    func refresh(notifications: [Notification],senders:[String:String])
}
extension NotificationsViewController:RefreshNotifications{
    func refresh(notifications: [Notification],senders: [String:String]) {
        self.notifications = notifications
        self.senders = senders
        if notificationsTableView != nil{
            notificationsTableView.reloadData()
        }
    }
}
