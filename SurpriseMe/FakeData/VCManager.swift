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
    var cartVC:CartViewController?
    var getters:[String:String]
    var cartCaller:UIViewController?
    var canInitCart:Bool
    //NOTIFICATIONS POP UP
    
    
    // ORDERS AND TREATS VIEW CONTROLLER
    var ordersAndTreatsVC:OrdersAndTreatsViewController?
    var treatsFromOrderArray:[Treat]
    var treatsFromOrder:Order?
    var initTreatsFromOrdeR:Bool
    
    //USERS NOT FRIENDS POP UP
    
    var usersPopUP:UsersPopUpViewController?
    var usersNum:Int
    var initUsersPopUpNotFriends:Bool
    var users:[User]
    var popUpParent:UIViewController?
    var cellDelegate:CartProductTableViewCell?
    
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
        getters = [:]
        cartVC = nil
        cartCaller = nil
        cellDelegate = nil
        canInitCart = true
        //NOTIFICATIONS POP UP
        
        
        // ORDERS AND TREATS VIEW CONTROLLER
        ordersAndTreatsVC = nil
        treatsFromOrderArray = []
        treatsFromOrder = nil
        initTreatsFromOrdeR = true
        
        //USERS NOT FRIENDS POP UP
        usersPopUP = nil
        usersNum = 0
        users = []
        initUsersPopUpNotFriends = true
        popUpParent = nil
        
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
    
    
    
    //init notFriends users PopUp
    func initUsersPopUP(refresh:Bool,withOutFriends:Bool,parent:UIViewController, cellDelegate: CartProductTableViewCell?){
        if initUsersPopUpNotFriends{
            self.cellDelegate = cellDelegate
            popUpParent = parent
            initUsersPopUpNotFriends = false
            users = []
            self.ref.child("users").observeSingleEvent(of: .value) { (usersData) in
                let usersDic = usersData.value as! [String:Any]
                if withOutFriends{
                    self.usersNum = usersDic.keys.count - CurrentUser.shared.get()!.friends.count - CurrentUser.shared.get()!.receivedFriendRequests.count - 1
                }else{
                    self.usersNum = usersDic.keys.count - 1
                }
                for key in usersDic.keys{
                    let someuser = User.getUserFromDictionary(usersDic[key] as! [String:Any])
                    var ok = true
                    if withOutFriends{
                        for friend in CurrentUser.shared.get()!.friends{
                            if someuser.id == friend{
                                ok = false
                            }
                        }
                    
                        for received in CurrentUser.shared.get()!.receivedFriendRequests{
                            if someuser.id == received{
                                ok = false
                            }
                        }
                    }
                    if ok , someuser.id != CurrentUser.shared.get()!.id {
                        self.users.append(someuser)
                    }
                }
            }
            
            if !refresh{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didNotFriendsLoaded(_:)), userInfo: nil, repeats: true)
            }else{
                
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshNotFriends(_:)), userInfo: nil, repeats: true)
            }
        }
    }
    @objc func refreshNotFriends(_ timer: Timer){
    
        
        if users.count == usersNum{
            timer.invalidate()
            //            if self.notFriendsPopUP == nil{
            //                self.notFriendsPopUP = (UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController)
            //                self.notFriendsPopUP!.users = []
            //            }                                 //new change
            //            if self.notFriendsPopUP != nil{
            initUsersPopUpNotFriends = true             //last change.
            let reloadDelegate:RefreshNotFriendsVC = self.usersPopUP!
            reloadDelegate.reloadMyData(users: self.users)
            
        }
    }
    @objc func didNotFriendsLoaded(_ timer: Timer){

        if users.count == usersNum {
            timer.invalidate()
            
//            if self.usersPopUP != nil{
//                self.usersPopUP!.delegate = cellDelegate

                //                initUsersPopUpNotFriends = true
//                let reloadDelegate:RefreshNotFriendsVC = self.usersPopUP!
//                reloadDelegate.reloadMyData(users: self.users)
//            } else{
                self.usersPopUP = (UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController)
                self.usersPopUP!.users = self.users
                self.usersPopUP!.currentUsers = self.users
                self.usersPopUP!.delegate = cellDelegate

            }
            
            
            //            userAddedDelegate = usersVC
            //            userAddedDelegate?.reloadMydata()
            initUsersPopUpNotFriends = true
            if let _ = popUpParent as? ProfileViewController{
//            self.usersPopUP!.delegate = VCManager.shared.profileVC!
            if menu.toggle {
                VCManager.shared.profileVC!.toggle = true
            }
                self.usersPopUP?.removeFromParent()

            VCManager.shared.profileVC!.toggle = PopUp.toggle(child: self.usersPopUP!, parent: VCManager.shared.profileVC!,toggle: VCManager.shared.profileVC!.toggle)
            }else{
                self.usersPopUP?.removeFromParent()
                let _ = PopUp.toggle(child: self.usersPopUP!, parent: VCManager.shared.cartVC!, toggle: true)
            }
//        }`
    }
    
    
    
    
    
    
    // init CartVC
    
    func initCartVC(caller:UIViewController){
        if canInitCart{
            cartCaller = caller
            let cartTreats = CurrentUser.shared.get()!.myCart
            getters = [:]
            for i in 0..<cartTreats.count{
                if cartTreats[i].getter != nil{
                    print(i,"ifelse")
                    self.ref.child("users").child(cartTreats[i].getter!).observeSingleEvent(of: .value) { (userData) in
                        let user = User.getUserFromDictionary(userData.value as! [String:Any])
                        self.getters[cartTreats[i].id] = user.fullName
                    }
                }else{
                    print(i,"else")
                    getters[cartTreats[i].id] = "click here ->"
                    print(getters.count,"elseCount")
                }
            }
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.cartLoad(_:)), userInfo: nil, repeats: true)
        }
    }
    
    @objc func cartLoad(_ timer:Timer){
        print(CurrentUser.shared.get()!.myCart.count,"CARTC")
        print(getters.count,"CAR")
        if CurrentUser.shared.get()!.myCart.count == getters.count{
            timer.invalidate()
            if cartVC == nil{
                self.cartVC = (UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as! CartViewController)
            }
            cartVC!.getters = getters
            if cartVC!.cartTableView != nil{
                let cartDelegate:updateCartDelegate = self.cartVC!
//                cartVC!.cartTableView.reloadData()
                cartDelegate.update()
            }
            cartCaller!.navigationController?.pushViewController(cartVC!, animated: false)
        }
    }
    
    
    
    
    
    func initTreatsForOrder(order:Order,vc: OrdersAndTreatsViewController){
        if initTreatsFromOrdeR{
            initTreatsFromOrdeR = false
            ordersAndTreatsVC = vc
            treatsFromOrderArray = []
            getters = [:]
            treatsFromOrder = order
            for treatId in order.treats{
                self.ref.child("allTreats").child(treatId).observeSingleEvent(of: .value) { (treatData) in
                    print(treatData,"data")
                    let treat = Treat.getTreatFromDictionary(treatData.value as! [String : Any])
                    self.treatsFromOrderArray.append(treat)
                    
                    
                    self.ref.child("users").child(treat.getter!).observeSingleEvent(of: .value) { (userData) in
                        let user = User.getUserFromDictionary(userData.value as! [String:Any])
                        self.getters[treat.id] = user.fullName
                    }
                    
                    
                    
                    
                }
            }
        
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.loadTreatsFromOrder(_:)), userInfo: nil, repeats: true)
        }
    }
    @objc func loadTreatsFromOrder(_ timer:Timer){

        if treatsFromOrderArray.count == treatsFromOrder?.treats.count{
            timer.invalidate()
            initTreatsFromOrdeR = true
            let orderedTreatsVC = UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orderedTreatsController") as! OrderedTreatsViewController
            orderedTreatsVC.treats = treatsFromOrderArray
            orderedTreatsVC.getters = getters
            let _ = PopUp.toggle(child: orderedTreatsVC, parent: self.ordersAndTreatsVC!,toggle:true)
            
        }
    }
    
    
    
    
    
}

