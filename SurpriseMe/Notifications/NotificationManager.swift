//
//  NotificationManager.swift
//  SurpriseMe
//
//  Created by Youval Ella on 03/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class NotificationManager{
        
        static let shared = NotificationManager()
    var ref:DatabaseReference
    
        private init(){
            ref = Database.database().reference()
        }
    
    
    func approveNotification(notification : Notification){
        switch notification.notificationType{
        case .isTreatRequest:
            
            //approve the treat
    ref.child("treats").child(CurrentUser.shared.get()!.id).child(notification.treatID!).child("status").setValue(TreatStatus.Accepted.rawValue)
            
            
        case .isFriendRequest:
            UsersManager.shared.add(friend: notification.sender)
            
        }
        
        //delete from notifications on server
        ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification.id!).removeValue()
    }
    
    func declineNotification(notification: Notification){
        var treat:Treat?
        //added this line because the block doesn't "know" the parameter
        let myNotification = notification
        //if its a treat notification
        switch notification.notificationType{
        case .isTreatRequest:
            //creating a treat using the ID
            ref.child("treats").child(CurrentUser.shared.get()!.id).child(notification.treatID!).observeSingleEvent(of: .value) { (datasnapshot) in
                
                let dic = datasnapshot.value as! [String:Any]
                treat = Treat.getTreatFromDictionary(dic)
                
                treat!.treatStatus = TreatStatus.Declined
                
                //write to declined
                self.ref.child("declinedTreats").child(myNotification.sender).child(myNotification.treatID!).setValue(treat!.toDB)
                
                //removed from treats
                self.ref.child("treats").child(CurrentUser.shared.get()!.id).child(myNotification.treatID!).removeValue()
                
            }
            
        case .isFriendRequest:
            UsersManager.shared.deny(friend: notification.sender)
            
        }
        ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification.id!).removeValue()
    }
    
    
    
    
    
//    func approveTreatNotification(treatID : String){
//        ref.child("treats").child(CurrentUser.shared.get()!.id).child(treatID).child("status").setValue(TreatStatus.Accepted.rawValue)
//    }
//
//    func declineTreatNotification(treatID: String){}
}


