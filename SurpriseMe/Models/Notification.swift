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
        return "\(sender) \(notificationType.getDescription())"
    }
    let date: Date?

    var image:UIImage?{
        if imageName != nil{
            return UIImage(named:  imageName!)
        }
        return #imageLiteral(resourceName: "placeholder")
    }
    let imageName : String?
    let sender : String
    let notificationType : NotificationType
    
    var toDB:[String:Any]{
        var dic:[String:Any] = [:]
        
        dic["title"] = title
        dic["description"] = description
        dic["date"] = ServerValue.timestamp()
        dic["imageName"] = imageName
        dic["sender"] = sender
        dic["notificationType"] = notificationType.rawValue
        return dic
    }
    
    static func getNotificationFromDictionary(_ dic:[String:Any]) -> Notification{
        
//        let title = dic["title"] as! String
//        let description = dic["description"] as! String
        let t = dic["date"] as! TimeInterval
        let date = Date(timeIntervalSince1970: t/1000)
        let imageName = dic["imageName"] as? String
        let sender = dic["sender"] as! String
        let notificationType = NotificationType(rawValue: dic["notificationType"] as! Int)
        
        return Notification(date: date, imageName: imageName, sender: sender, notificationType: notificationType!)
        
    }
}

enum NotificationType: Int, CustomStringConvertible{
    case isFriedRequest = 0 , isTreatRequest
    
    var description: String{
        switch self{
        case .isFriedRequest: return "You have a new friend request!"
        case .isTreatRequest : return "You have a new treat request!"
        }
    }
    
    func getDescription()-> String{
        switch self{
        case .isFriedRequest: return "is requesting to be your friend"
        case .isTreatRequest : return "is requesting to send you a treat"
        }
    }
}


//todo improve the date appearance.
//todo make the name of the sender appear in the notification
//todo make the accept and decline work for both types of notifications
