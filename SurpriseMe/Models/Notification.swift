//
//  File.swift
//  SurpriseMe
//
//  Created by Youval Ella on 31/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

struct Notification{
    let title: String
    let description: String
    let date: Date
    let image : UIImage?
    let sender : User?
    let notificationType : NotificationType
}

enum NotificationType: Int, CustomStringConvertible{
    case isFriedRequest = 0 , isTreatRequest
    
    var description: String{
        switch self{
        case .isFriedRequest: return "You have a new friend request"
        case .isTreatRequest : return "You have a new treat request"
        }
    }
    
    func getDescription()-> String{
        switch self{
        case .isFriedRequest: return "is requesting to be your friend"
        case .isTreatRequest : return "is requesting to send you a treat"
        }
    }
}
