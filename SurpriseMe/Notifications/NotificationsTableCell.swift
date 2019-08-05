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
    
    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var notificationDescription: UILabel!
    
    @IBOutlet weak var notificationDate: UILabel!
    
    @IBAction func acceptTapped(_ sender: UIButton) {
        let ref = Database.database().reference()
        
        //approve the treat
        ref.child("treats").child(CurrentUser.shared.get()!.id).child(notification!.treatID!).child("status").setValue(TreatStatus.Accepted.rawValue)
        
        
        //delete from notifications
        
        ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification!.id!).removeValue()
        
    }
    
    @IBAction func denyTapped(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(notification : Notification?){
        self.notification = notification
        notificationImage.image = notification!.image?.circleMasked ?? #imageLiteral(resourceName: "placeholder").circleMasked
        notificationTitle.text = notification!.title
        notificationDescription.text = notification!.description
        notificationDate.text = "\(notification!.date!)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

protocol ChangedNotificationStateDelegate{
    func stateChanged()
}
