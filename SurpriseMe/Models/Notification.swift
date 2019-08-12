//
//  File.swift
//  SurpriseMe
//
//  Created by Youval Ella on 31/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

struct Notification{
    var title: String{
        return notificationType.description
    }
    var description: String{
//        return "\(sender) \(notificationType.getDescription())"
        return "\(notificationType.getDescription())"

    }
    let date: Date?

    var image:UIImage?{
        if imageName != nil{
            return UIImage(named:  imageName!)
        }
        return #imageLiteral(resourceName: "placeholder")
    }
    var id:String?
    let imageName : String?
    let sender : String
    let notificationType : NotificationType
    let treatID : String?
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        dic["id"] = id!
        dic["title"] = title
        dic["description"] = description
        dic["date"] = ServerValue.timestamp()
        dic["imageName"] = imageName
        dic["sender"] = sender
        dic["notificationType"] = notificationType.rawValue
        
        if treatID != nil{
            dic["treatID"] = treatID
        }
        return dic
    }
    
    static func getNotificationFromDictionary(_ dic:[String:Any]) -> Notification{
        
//        let title = dic["title"] as! String
//        let description = dic["description"] as! String
        let id = dic["id"] as! String
        let t = dic["date"] as! TimeInterval
        let date = Date(timeIntervalSince1970: t/1000)
        let imageName = dic["imageName"] as? String
        let sender = dic["sender"] as! String
        let notificationType = NotificationType(rawValue: dic["notificationType"] as! Int)
        let treatID = dic["treatID"] as? String
        return Notification(date: date, id: id, imageName: imageName, sender: sender, notificationType: notificationType!, treatID: treatID)
        
    }
}

enum NotificationType: Int, CustomStringConvertible{
    case isFriendRequest = 0 , isTreatRequest , isTreatApproval , isTreatDecline , isFriendApproval , isFriendDecline
    
    var description: String{
        switch self{
        case .isFriendRequest: return "You have a new friend request!"
        case .isTreatRequest : return "You have a new treat request!"
        case .isTreatApproval: return "Your treat has been accepted!"
        case .isTreatDecline: return "Your treat has been declined!"
        case .isFriendApproval: return "Your friend request has been approved!"
        case .isFriendDecline: return "Your friend request has been declined!"
        }
    }
    
    func getDescription()-> String{
        switch self{
        case .isFriendRequest: return "is requesting to be your friend"
        case .isTreatRequest : return "is requesting to send you a treat"
        case .isTreatApproval: return " has received your treat!"
        case .isTreatDecline: return " has decided to decline your treat!"
        case .isFriendApproval: return "and you are now friends! Congrats."
        case .isFriendDecline: return " has decided to decline your friend request, Sorry."
        }
    }
}


//todo improve the date appearance.
//todo make the name of the sender appear in the notification
//todo make the accept and decline work for both types of notifications
