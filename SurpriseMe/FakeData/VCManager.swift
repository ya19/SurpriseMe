//
//  VCManager.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class VCManager{
    
    static let shared = VCManager()
    
    private let ref = Database.database().reference()
    
    //PROFILE VIEW CONTROLLER
    
    var profileVC:ProfileViewController?
    private var currentFriends:[String]
    private var currentRequests:[String]
    var friends:[User]
    var requests:[User]
    var initFriends:Bool
    var initRequests:Bool
    var reloadProfileVC:RefreshProfileVC?
    
    //CART VIEW CONTROLLER
    
    
    //NOTIFICATIONS POP UP
    
    
    // ORDERS AND TREATS VIEW CONTROLLER
    
    
    //USERS NOT FRIENDS POP UP
    
    var notFriendsPopUP:UsersPopUpViewController?
    private var NotFriendsUsersNum:Int
    var initUsersPopUpNotFriends:Bool
    var notFriends:[User]
    
    
    private init(){
        
        //PROFILE VIEW CONTROLLER
        friends = []
        requests = []
        profileVC = nil
        currentFriends = []
        currentRequests = []
        initFriends = true
        initRequests = true
        reloadProfileVC = nil
        //CART VIEW CONTROLLER
        
        
        //NOTIFICATIONS POP UP
        
        
        // ORDERS AND TREATS VIEW CONTROLLER
        
        
        //USERS NOT FRIENDS POP UP
        notFriendsPopUP = nil
        NotFriendsUsersNum = 0
        notFriends = []
        initUsersPopUpNotFriends = true
        
    }
    
    
    
    // init profile view controller
    // including init friends and requests arrays.(2 methods)
    
    //init profile viewcontroller from the menu
    func initProfileVC(){
        print("friends", initFriends)
        print("requests",initRequests)
        if initFriends , initRequests{
            initFriends = false
            initRequests = false
            self.friends = []
            self.requests = []
            currentFriends = CurrentUser.shared.get()!.friends
            currentRequests = CurrentUser.shared.get()!.receivedFriendRequests
        
            for friend in currentFriends{
                self.ref.child("users").child(friend).observeSingleEvent(of: .value) { (friendData) in
                    let user = User.getUserFromDictionary(friendData.value as! [String:Any])
                    self.friends.append(user)
                }
            }
        
            for request in currentRequests{
                self.ref.child("users").child(request).observeSingleEvent(of: .value) { (requestData) in
                    let user = User.getUserFromDictionary(requestData.value as! [String:Any])
                    self.requests.append(user)
                }
            }
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFriendsAndRequestsLoaded(_:)), userInfo: nil, repeats: true)

            
        }
    }
    
    
    @objc func didFriendsAndRequestsLoaded(_ timer: Timer){
        if friends.count == currentFriends.count , requests.count == currentRequests.count{
            timer.invalidate()
            
            if self.profileVC != nil{
                reloadProfileVC?.reloadMyData(friends: friends, requests: requests)
            }else{
                self.profileVC = (UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController)
                reloadProfileVC = self.profileVC
                
                self.profileVC!.friends = friends
                self.profileVC!.requests = requests
            }
            
            menu.parent?.navigationController?.pushViewController(self.profileVC!, animated: true)
            menu.removeFromParent()
            initFriends = true
            initRequests = true
        }
    }
    
    //update friends array
    func updateFriendsProfileVC(){
        if initFriends{
            initFriends = false
            self.friends = []
            currentFriends = CurrentUser.shared.get()!.friends
            for friend in currentFriends{
                self.ref.child("users").child(friend).observeSingleEvent(of: .value) { (friendData) in
                    let user = User.getUserFromDictionary(friendData.value as! [String:Any])
                    self.friends.append(user)
                }
            }
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshFriends(_:)), userInfo: nil, repeats: true)

        }
    }
    //making sure the FRIENDS update has finished and updating UI
    @objc func refreshFriends(_ timer: Timer){
        if friends.count == currentFriends.count{
            timer.invalidate()

            if self.profileVC == nil{
                self.profileVC = (UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController)
                reloadProfileVC = self.profileVC
            }else{
                reloadProfileVC?.reloadMyData(friends: friends, requests: nil)
            }
            
            
            initFriends = true
        }
    }
    
    
    

    
    //update requests array
    func updateRequestsProfileVC(){
        if initRequests{
            initRequests = false
            self.requests = []
            currentRequests = CurrentUser.shared.get()!.receivedFriendRequests
            for request in currentRequests{
                self.ref.child("users").child(request).observeSingleEvent(of: .value) { (requestData) in
                    let user = User.getUserFromDictionary(requestData.value as! [String:Any])
                    self.requests.append(user)
                }
            }
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshRequests(_:)), userInfo: nil, repeats: true)
            
        }
    }
   
    //making sure the REQUESTS update has finished and updating UI
    @objc func refreshRequests(_ timer: Timer){
        if requests.count == currentRequests.count{
            timer.invalidate()
            
            if self.profileVC == nil{
                self.profileVC = (UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController)
                reloadProfileVC = self.profileVC
            }else{
                reloadProfileVC?.reloadMyData(friends: nil, requests: requests)
            }
            
            
            initRequests = true
        }
    }
}
