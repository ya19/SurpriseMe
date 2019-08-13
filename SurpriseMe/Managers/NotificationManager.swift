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
    
    
    func sendNotification(friendID : String , notificationType : NotificationType , treatID: String?){
        
        var notification = Notification.init(date: nil, id: nil, imageName: nil, sender: CurrentUser.shared.get()!.id, notificationType: notificationType, treatID: treatID)
        
        let key = self.ref.child("notifications").child(friendID).childByAutoId().key! as String
        notification.id = key
        self.ref.child("notifications").child(friendID).child(key).setValue(notification.toDB)
    }
    
    func removeNotification(notificationID: String){
        ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notificationID).removeValue()
    }
    
    func removeFriendRequestNotification(friendID: String){
        for notification in CurrentUser.shared.get()!.notifications{
            if notification.sender == friendID , notification.notificationType == .isFriendRequest{
                ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification.id!).removeValue()
            }
        }
    }
    
    func removeTreatRequestNotification(friendID: String , treatID : String){
        for notification in CurrentUser.shared.get()!.notifications{
            if notification.sender == friendID , notification.notificationType == .isTreatRequest , notification.treatID == treatID{
                ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification.id!).removeValue()
            }
        }
    }
    
    
    func approveNotification(notification : Notification){
        var treat:Treat?
        switch notification.notificationType{
        case .isTreatRequest:
            
            //approve the treat
//            ref.child("treats").child(CurrentUser.shared.get()!.id).child(notification.treatID!).observeSingleEvent(of: .value) { (datasnapshot) in
            
                ref.child("allTreats").child(notification.treatID!).observeSingleEvent(of: .value, with: { (DataSnapshot) in
                    treat = Treat.getTreatFromDictionary(DataSnapshot.value as! [String:Any])
                    TreatManager.shared.acceptTreat(treat: treat , fromNotification: true)
                })
                
                
            
            
            
        case .isFriendRequest:
            UsersManager.shared.add(friend: notification.sender)
           
        default : return
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
            
            
//            //creating a treat using the ID
            ref.child("allTreats").child(notification.treatID!).observeSingleEvent(of: .value, with: { (DataSnapshot) in
                treat = Treat.getTreatFromDictionary(DataSnapshot.value as! [String:Any])
                TreatManager.shared.declineTreat(treat: treat , fromNotification: true)
            })

            
            
            
        case .isFriendRequest:
            UsersManager.shared.deny(friend: notification.sender)
            
        default : return
        }
        ref.child("notifications").child(CurrentUser.shared.get()!.id).child(notification.id!).removeValue()
    }
    
    
    
    
    
//    func approveTreatNotification(treatID : String){
//        ref.child("treats").child(CurrentUser.shared.get()!.id).child(treatID).child("status").setValue(TreatStatus.Accepted.rawValue)
//    }
//
//    func declineTreatNotification(treatID: String){}
}


