//
//  NotificationsTableCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 31/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class NotificationsTableCell: UITableViewCell {

    var notification:Notification?
    var delegate : ChangedNotificationStateDelegate?
    
    
    @IBOutlet weak var declineBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var notificationDescription: UILabel!
    
    @IBOutlet weak var notificationDate: UILabel!
    
    @IBAction func acceptTapped(_ sender: UIButton) {

        NotificationManager.shared.approveNotification(notification: notification!)

        
    }
    
    @IBAction func denyTapped(_ sender: Any) {
        
        NotificationManager.shared.declineNotification(notification: notification!)



    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(notification : Notification?,senderName: String,senderImage:UIImage){
        self.notification = notification
        notificationImage.image = senderImage.circleMasked
        notificationTitle.text = notification!.title
        notificationDescription.text = "\(senderName) \(notification!.description)"
        notificationDate.text = "\(notification!.dateString)"
        
        if notification?.notificationType == NotificationType.isTreatRequest || notification?.notificationType == NotificationType.isFriendRequest{
            acceptBtn.isHidden = false
            declineBtn.isHidden = false
        } else {

            acceptBtn.isHidden = true
            declineBtn.isHidden = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

protocol ChangedNotificationStateDelegate{
    func stateChanged()
}

