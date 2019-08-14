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
    private let storage = Storage.storage().reference()
    
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
    var notificationsVC:NotificationsViewController?
    var notifications:[Notification]
    var canInitNotifications:Bool
    var notificationsNum:Int
    var refreshNotifications:RefreshNotifications?
    var notificationsToggle:Bool
    var notificationsCaller:UIViewController?
    var notificationsSenders:[String:User]
    // ORDERS AND TREATS VIEW CONTROLLER
    var ordersAndTreatsVC:OrdersAndTreatsViewController?
    var treatsFromOrderArray:[Treat]
    var treatsFromOrder:Order?
    var initTreatsFromOrdeR:Bool
    
    var myTreats:[Treat]
    var myTreatsGivers:[String:String]
    var canInitTreats:Bool
    var currentTreatsNum:Int
    var refreshTreats:RefreshTreats?
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
        notificationsVC = nil
        notifications = []
        canInitNotifications = true
        notificationsNum = 0
        refreshNotifications = nil
        notificationsToggle = true
        notificationsCaller = nil
        notificationsSenders = [:]
        // ORDERS AND TREATS VIEW CONTROLLER
        ordersAndTreatsVC = nil
        treatsFromOrderArray = []
        treatsFromOrder = nil
        initTreatsFromOrdeR = true
        
        myTreats = []
        myTreatsGivers = [:]
        canInitTreats = true
        currentTreatsNum = 0
        refreshTreats =  nil
        //USERS NOT FRIENDS POP UP
        usersPopUP = nil
        usersNum = 0
        users = []
        initUsersPopUpNotFriends = true
        popUpParent = nil
        
    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
                    var user = User.getUserFromDictionary(friendData.value as! [String:Any])
                    self.storage.child(friend).downloadURL(completion: { (URL, Error) in
                        self.getData(from: URL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                        
                            DispatchQueue.main.async() {
                                user.image = UIImage(data: data)
                                self.friends.append(user)
                            }
                        }
                    })
                 
                    
                }
            }
        
            for request in currentRequests{
                self.ref.child("users").child(request).observeSingleEvent(of: .value) { (requestData) in
                    var user = User.getUserFromDictionary(requestData.value as! [String:Any])
                    self.storage.child(request).downloadURL(completion: { (URL, Error) in
                        self.getData(from: URL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                       
                            DispatchQueue.main.async() {
                                user.image = UIImage(data: data)
                                self.requests.append(user)
                            }
                        }
                    })                }
            }
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFriendsAndRequestsLoaded(_:)), userInfo: nil, repeats: true)

            
        }
    }
    
    
    @objc func didFriendsAndRequestsLoaded(_ timer: Timer){
        if friends.count == currentFriends.count , requests.count == currentRequests.count{
            
            //sort by full name
            friends = friends.sorted(by: { (u1, u2) -> Bool in
                u1.fullName < u2.fullName
            })
            
            
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
                    var user = User.getUserFromDictionary(friendData.value as! [String:Any])
                    self.storage.child(friend).downloadURL(completion: { (URL, Error) in
                        self.getData(from: URL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                        
                            DispatchQueue.main.async() {
                                user.image = UIImage(data: data)
                                self.friends.append(user)
                            }
                        }
                    })
                }
            }
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshFriends(_:)), userInfo: nil, repeats: true)

        }
    }
    //making sure the FRIENDS update has finished and updating UI
    @objc func refreshFriends(_ timer: Timer){
        if friends.count == currentFriends.count{
            timer.invalidate()
            //sort by full name
            friends = friends.sorted(by: { (u1, u2) -> Bool in
                u1.fullName < u2.fullName
            })

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
                    var user = User.getUserFromDictionary(requestData.value as! [String:Any])
                    self.storage.child(request).downloadURL(completion: { (URL, Error) in
                        self.getData(from: URL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                       
                            DispatchQueue.main.async() {
                                user.image = UIImage(data: data)
                                self.requests.append(user)
                            }
                        }
                    })
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
                    var someuser = User.getUserFromDictionary(usersDic[key] as! [String:Any])
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
                        
                        self.storage.child(someuser.id).downloadURL(completion: { (URL, Error) in
                            self.getData(from: URL!) { data, response, error in
                                guard let data = data, error == nil else { return }
                                DispatchQueue.main.async() {
                                    someuser.image = UIImage(data: data)
                                     self.users.append(someuser)
                                }
                            }
                        })
                        
                       
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
            //sort by full name
            users = users.sorted(by: { (u1, u2) -> Bool in
                u1.fullName < u2.fullName
            })

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
            
            //sort by full name
            users = users.sorted(by: { (u1, u2) -> Bool in
                u1.fullName < u2.fullName
            })
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
                self.usersPopUP!.cellDelegate = cellDelegate
            
            
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
        }
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
    
    
    
    
    //no need to sort, its being created in the same date.
    func initTreatsForOrder(order:Order){
        if initTreatsFromOrdeR{
            initTreatsFromOrdeR = false
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
    
    
    
    //INIT NOTIFICATIONS
    
    func initNotifications(refresh:Bool,caller: UIViewController?){
        if canInitNotifications{
            notificationsCaller = caller
            notifications = []
            notificationsSenders = [:]
            notificationsNum = CurrentUser.shared.get()!.notifications.count
            
            for i in 0..<notificationsNum{
                let not = CurrentUser.shared.get()!.notifications[i]
                notifications.append(not)
                self.ref.child("users").child(not.sender).observeSingleEvent(of: .value) { (userData) in
                    var user = User.getUserFromDictionary(userData.value as! [String:Any])
                    self.storage.child(user.id).downloadURL(completion: { (URL, Error) in
                        self.getData(from: URL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                            DispatchQueue.main.async() {
                                user.image = UIImage(data: data)
                                self.notificationsSenders[not.id!] = user
                            }
                        }
                    })
                    
                }
            }
            

            
            if refresh{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshNotifications(_:)), userInfo: nil,   repeats: true)
            }else{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.loadNotifications(_:)), userInfo: nil, repeats: true)
            }
        }
    }
    
    
    @objc func loadNotifications(_ timer:Timer){
        if notifications.count == notificationsNum , notificationsSenders.count == notificationsNum{
            timer.invalidate()
            notifications = notifications.sorted(by: { (n1, n2) -> Bool in
                return n1.date! > n2.date!
            })
            
            //loadnot
            if notificationsVC == nil{
                notificationsVC = (UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController)
                notificationsVC!.notifications = self.notifications
                notificationsVC!.senders = self.notificationsSenders
                refreshNotifications = notificationsVC!
            }else{
                refreshNotifications?.refresh(notifications: self.notifications, senders: self.notificationsSenders)
            }
            canInitNotifications = true
            if menu.toggle {
                notificationsToggle = true
            }
            self.notificationsToggle = PopUp.toggle(child: notificationsVC!, parent: notificationsCaller!, toggle: self.notificationsToggle)
            
        }
    }
    
    @objc func refreshNotifications(_ timer:Timer){
        if notifications.count == notificationsNum , notificationsSenders.count == notificationsNum{
            timer.invalidate()
            notifications = notifications.sorted(by: { (n1, n2) -> Bool in
                return n1.date! > n2.date!
            })
            
            if notificationsVC == nil{
                notificationsVC = (UIStoryboard(name: "Notifications", bundle: nil).instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController)
                notificationsVC!.notifications = self.notifications
                notificationsVC!.senders = self.notificationsSenders
                refreshNotifications = notificationsVC!
            }else{
                refreshNotifications?.refresh(notifications: self.notifications, senders: self.notificationsSenders)
            }
            canInitNotifications = true
            //refresh not
        }
    }
    
    // INIT MY TREATS
    
    func initMyTreats(refresh:Bool){
        if canInitTreats{
            canInitTreats = false
            myTreatsGivers = [:]
            myTreats = []
            currentTreatsNum = CurrentUser.shared.get()!.myTreats.count
            
            for i in 0..<currentTreatsNum{
                let treat = CurrentUser.shared.get()!.myTreats[i]
                myTreats.append(treat)
                self.ref.child("users").child(treat.giver!).observeSingleEvent(of: .value) { (userData) in
                    let user = User.getUserFromDictionary(userData.value as! [String:Any])
                    self.myTreatsGivers[treat.id] = user.fullName
                }
            }
            

            
            if refresh{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshMyTreats(_:)), userInfo: nil,   repeats: true)
            }else{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.loadMyTreats(_:)), userInfo: nil, repeats: true)
            }
        }
    }


    @objc func loadMyTreats(_ timer:Timer){
        if myTreats.count == currentTreatsNum , myTreatsGivers.count == currentTreatsNum{
            timer.invalidate()
            myTreats = myTreats.sorted(by: { (t1, t2) -> Bool in
                return t1.date! < t2.date!
            })
            
            if ordersAndTreatsVC == nil{
                ordersAndTreatsVC = (UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersAndTreatsViewController)
                ordersAndTreatsVC!.myTreats = myTreats
                ordersAndTreatsVC!.myTreatsGivers = myTreatsGivers
                refreshTreats = ordersAndTreatsVC!
            }else{
                refreshTreats?.refresh(myTreats: self.myTreats, myTreatsGivers: self.myTreatsGivers)
            }
            menu.parent?.navigationController?.pushViewController(ordersAndTreatsVC!, animated: true)
            menu.removeFromParent()
            canInitTreats = true
            
        }
    }

    @objc func refreshMyTreats(_ timer:Timer){
        if myTreats.count == currentTreatsNum , myTreatsGivers.count == currentTreatsNum{

            timer.invalidate()
            myTreats = myTreats.sorted(by: { (t1, t2) -> Bool in
                return t1.date! < t2.date!
            })
            
            if ordersAndTreatsVC == nil{
                ordersAndTreatsVC = (UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersAndTreatsViewController)
                ordersAndTreatsVC!.myTreats = myTreats
                ordersAndTreatsVC!.myTreatsGivers = myTreatsGivers
                refreshTreats = ordersAndTreatsVC!
            }else{
                refreshTreats?.refresh(myTreats: self.myTreats, myTreatsGivers: self.myTreatsGivers)
            }
            

            canInitTreats = true
        }
    }
}

