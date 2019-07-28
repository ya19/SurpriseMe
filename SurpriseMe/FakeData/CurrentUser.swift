//
//  CurrentUser.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 27/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//
import UIKit
import Firebase

class CurrentUser{
    
    static let shared = CurrentUser()
    
    private var user:User
    
    private let ref = Database.database().reference()
    private init(){
        ref.child("users").child(Auth.auth().currentUser!.uid).observe(.value, with: { (datasnapshot) in
            guard let newCurrentUserDic = datasnapshot.value as? [String:Any] else{return}
            //                print("HELLLLLLLO")
           self.user  = User.getUserFromDictionary(newCurrentUserDic)

    })
    
    }
    
    func get() -> User{
        return user
    }
}
