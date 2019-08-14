//
//  TreatManager.swift
//  SurpriseMe
//
//  Created by Youval Ella on 13/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class TreatManager{

    var statusDelegate : TreatStatusChangedDelegate?
    static let shared = TreatManager()
    var ref:DatabaseReference
    
    private init(){
        ref = Database.database().reference()
    }
    
    
    func acceptTreat(treat : Treat? , fromNotification : Bool){
        
        //update status in server
        ref.child("allTreats").child(treat!.id).child("status").setValue(TreatStatus.Accepted.rawValue)
        
        //send notification for accept
        NotificationManager.shared.sendNotification(friendID: treat!.giver!, notificationType: .isTreatApproval, treatID: treat!.id)
        
        
        //delete my notification
        NotificationManager.shared.removeTreatRequestNotification(friendID: treat!.giver! , treatID: treat!.id)
        
        
        if VCManager.shared.ordersAndTreatsVC != nil{
            let updateDelegate : TreatStatusChangedDelegate = VCManager.shared.ordersAndTreatsVC!
            
            updateDelegate.updateStatus(treatID: treat!.id)
        }
//
//        if fromNotification{
//            if let delegate = OrdersAndTreatsViewController.self as? TreatStatusChangedDelegate{
//            delegate.updateStatus()
//                
//            }
//        }
        
    }
    
    func declineTreat(treat: Treat? , fromNotification : Bool){
       var myTreat = treat!
//        ref.child("treats").child(CurrentUser.shared.get()!.id).child(treat!.id).removeValue()
        
        var remember = -1
        ref.child("treats").child(CurrentUser.shared.get()!.id).observeSingleEvent(of: .value) { (DataSnapshot) in
            if var array = DataSnapshot.value as? [String]{
                
                for i in 0..<array.count{
                    if array[i] == treat!.id{
                        remember = i
                    }
                }
                
                if remember != -1{
                    array.remove(at: remember)
                self.ref.child("treats").child(CurrentUser.shared.get()!.id).setValue(array)
                }
            }
        }
        
        
        
        //updated status
        myTreat.treatStatus = .Declined
        //check if it changed only the status. otherwise just do set value on status.
        ref.child("allTreats").child(treat!.id).updateChildValues(myTreat.toDB)
        
        //wrote to server in declined treats.
        //        ref.child("declinedTreats").child(treat!.giver!).child(treat!.id).setValue(self.treat!.toDB)
        
        ref.child("declinedTreats").child(CurrentUser.shared.get()!.id).observeSingleEvent(of: .value) { (DataSnapshot) in
            
            var newArray:[String] = []
            if var array = DataSnapshot.value as? [String]{
                array.append(treat!.id)
                newArray = array
            } else {
                newArray.append(treat!.id)
            }
            
            self.ref.child("declinedTreats").child(CurrentUser.shared.get()!.id).setValue(newArray)
            
        }
        
       //changing price of the order.
        ref.child("orders").child(treat!.giver!).child(treat!.orderId!).child("price").observeSingleEvent(of: .value) { (datasnapshot) in
            if var price = datasnapshot.value as? Double{
                price -= treat!.product.price
            self.ref.child("orders").child(treat!.giver!).child(treat!.orderId!).child("price").setValue(price)
            }
        }
        
        
        //send notification for accept
        NotificationManager.shared.sendNotification(friendID: treat!.giver!, notificationType: .isTreatDecline, treatID: treat!.id)
        
        NotificationManager.shared.removeTreatRequestNotification(friendID: treat!.giver! , treatID: treat!.id)

//        if fromNotification{
//            statusDelegate = OrdersAndTreatsViewController.self as? TreatStatusChangedDelegate
//            statusDelegate?.updateStatus()
//        }
        
    }

}
