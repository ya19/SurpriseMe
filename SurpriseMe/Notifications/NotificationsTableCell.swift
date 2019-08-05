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
        
        
        switch notification!.notificationType{
        case .isTreatRequest:
            
            //approve the treat
            ref.child("treats").child(CurrentUser.shared.get()!.id).child(notification!.treatID!).child("status").setValue(TreatStatus.Accepted.rawValue)
            
        case .isFriendRequest:
            UsersManager.shared.add(friend: notification!.sender)
            
            
            
        }
        
        
        //delete from notifications
        ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification!.id!).removeValue()
        
    }
    
    @IBAction func denyTapped(_ sender: Any) {
        let ref = Database.database().reference()
        var treat:Treat?
       
        //if its a treat notification
        switch notification!.notificationType{
        case .isTreatRequest:
            //creating a treat using the ID
            ref.child("treats").child(CurrentUser.shared.get()!.id).child(notification!.treatID!).observeSingleEvent(of: .value) { (datasnapshot) in
                
                let dic = datasnapshot.value as! [String:Any]
                treat = Treat.getTreatFromDictionary(dic)
                
                treat!.treatStatus = TreatStatus.Declined
                
                //write to declined
                ref.child("declinedTreats").child(self.notification!.sender).child(self.notification!.treatID!).setValue(treat!.toDB)
                
                //removed from treats
                ref.child("treats").child(CurrentUser.shared.get()!.id).child(self.notification!.treatID!).removeValue()
                
                ref.child("notifications").child(CurrentUser.shared.get()!.id).child(self.notification!.id!).removeValue()
            }
            
        case .isFriendRequest:
            UsersManager.shared.deny(friend: notification!.sender)
            
        }
        

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
