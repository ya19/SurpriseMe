//
//  User.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

struct User{
    
    let id:String
    
    let email:String
    
    let firstName:String
    
    let lastName:String

    let dateOfBitrh:String
    
    let friends:[User]
    
    let treatsStatus:TreatStatus
    
}
