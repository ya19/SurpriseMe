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
        
        private var user:User?
        let ref = Database.database().reference()
        var finishAll:[String:Any]
        var vc:UIViewController?
        var asNavigation:Bool?
        var once = true
//        private var currentFriendsNum:Int
//        private var currentRequestsNum:Int
//        var friends:[User]
//        var requests:[User]
//        var profileVC:ProfileViewController?
        private init(){
          user = nil
            finishAll = [:]
            vc = nil
            asNavigation = nil
//            friends = []
//            requests = []
//            profileVC = nil
//            currentFriendsNum = 0
//            currentRequestsNum = 0
        }
        
//        func initFriendsVC(refresh:Bool) {
//            friends = []
//            requests = []
//            currentRequestsNum = CurrentUser.shared.get()!.receivedFriendRequests.count
//            currentFriendsNum = CurrentUser.shared.get()!.friends.count
//                for friendId in CurrentUser.shared.get()!.friends{
//                    self.ref.child("users").child(friendId).observeSingleEvent(of: .value, with: { (friendData) in
//                        self.friends.append(User.getUserFromDictionary(friendData.value as! [String:Any]))
//                    })
//            }
//
//            for friendRequestId in CurrentUser.shared.get()!.receivedFriendRequests{
//                self.ref.child("users").child(friendRequestId).observeSingleEvent(of: .value, with: { (requestData) in
//
//                    self.requests.append(User.getUserFromDictionary(requestData.value as! [String:Any]))
//                })
//
//            }
//            if !refresh{
//                    Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFriendsLoaded(_:)), userInfo: nil, repeats: true)
//            }else{
//
//                    Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshFriends(_:)), userInfo: nil, repeats: true)
//            }
//
//        }
//        @objc func refreshFriends(_ timer: Timer){
//            if friends.count == currentFriendsNum , requests.count == currentRequestsNum{
//                timer.invalidate()
//
//                let reloadDelegate:RefreshProfileVC = self.profileVC!
//                reloadDelegate.reloadMyData(friends: self.friends,requests: self.requests)
//            }
//        }
//        @objc func didFriendsLoaded(_ timer: Timer){
//            print(friends.count , "-" , currentFriendsNum, "$$$" , requests.count , "-" , currentRequestsNum)
//
//            if friends.count == currentFriendsNum , requests.count == currentRequestsNum{
//                timer.invalidate()
//    //                    let friendsVC = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "friends") as! FriendsViewController
//                if self.profileVC == nil{
//                let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController
//                //profile view controller
//    //                    friendsVC.friends = self.friends
//                self.profileVC = profileVC
//                }
//                        self.profileVC!.friends = self.friends
//                        self.profileVC!.requests = self.requests
//
//                        menu.parent?.navigationController?.pushViewController(self.profileVC!, animated: true)
//                menu.removeFromParent()
//
//            }
//        }
        func get() -> User?{
            return user
        }
        func configure(_ vc:UIViewController , asNavigation : Bool){
            self.vc = vc
            self.asNavigation = asNavigation
            once = true
            finishAll = [:]
            ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (datasnapshot) in
                let dic = datasnapshot.value as! [String:Any]
                
                let id = dic["id"] as! String
//                let email = dic["email"] as! String
//                let firstName = dic["firstName"] as! String
//                let lastName = dic["lastName"] as! String
//                let myTimeInterval = TimeInterval(dic["dateOfBirth"] as! Double)
//                let dateOfBirth = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
//                let getTreatStatus = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)!
//                let address:[String:String]? = nil // write to server and get from server in address list
                self.finishAll["id"] = dic["id"] as! String
                self.finishAll["email"] = dic["email"] as! String
                self.finishAll["firstName"] = dic["firstName"] as! String
                self.finishAll["lastName"] = dic["lastName"] as! String
                let myTimeInterval = TimeInterval(dic["dateOfBirth"] as! Double)
                self.finishAll["dateOfBirth"] = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
                self.finishAll["getTreatStatus"] = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)!
//                let address:[String:String]? = nil // write to server and get from server in address list
                self.finishAll["address"] = nil

                
                self.ref.child("friends").child(id).observe(.value, with: { (friendsData) in

                    var friends:[String] = []
                        if let friendsArr = friendsData.value as? [String]{
    //                        self.delegate?.doneReadingFriends()
                        friends = friendsArr // todo check if it works.
                        }
                    if self.once{
                        self.finishAll["friends"] = friends
                    }else{
                        self.user!.friends = friends
                        VCManager.shared.updateFriendsProfileVC()
                        if VCManager.shared.profileVC?.toggle == false{
                            UsersManager.shared.initUsersPopUpFromProfile(refresh: true)
                        }
                    }
                })
                self.ref.child("orders").child(id).observe( .value, with: { (ordersData) in

                    var myOrders:[Order] = []
                    if let ordersDic = ordersData.value as? [String:Any]{
                        for key in ordersDic.keys{
                            myOrders.append(Order.getOrderFromDictionary(ordersDic[key] as! [String:Any]))
                        }
                    }
                    if self.once{
                        self.finishAll["myOrders"] = myOrders
                    }else{
                        self.user!.myOrders = myOrders
                    }
                })
                self.ref.child("treats").child(id).observe( .value, with: { (treatsData) in
      
                    var myTreats:[Treat] = []
                    if let treatsDic = treatsData.value as? [String:Any]{
                        for key in treatsDic.keys{
                            myTreats.append(Treat.getTreatFromDictionary(treatsDic[key] as! [String:Any]))
                        }
                    }
                    if self.once{
                        self.finishAll["myTreats"] = myTreats
                    }else{
                        self.user!.myTreats = myTreats
                    }
                })
                self.ref.child("myCart").child(id).observe(.value, with: { (cartData) in
                                

                    var myCart:[Treat] = []
                    if let cartDic = cartData.value as? [String:Any]{
                        for key in cartDic.keys{
                            myCart.append(Treat.getTreatFromDictionary(cartDic[key] as! [String:Any]))
                            myCart = myCart.sorted(by: { (t1, t2) -> Bool in
                                return Int((t1.date?.timeIntervalSince1970)!) < Int((t2.date?.timeIntervalSince1970)!)
                            })
                        }
                    }
                    if self.once{
                        self.finishAll["myCart"] = myCart
                    }else{
                        self.user!.myCart = myCart
                    }
                })
                self.ref.child("sentFriendRequests").child(id).observe(.value, with: { (sentData) in
                                        

                    var sentFriendRequests:[String] = []
                    if let sent = sentData.value as? [String]{
                        sentFriendRequests = sent
                    }
                    if self.once{
                        self.finishAll["sent"] = sentFriendRequests
                    }else{
                        self.user!.sentFriendRequests = sentFriendRequests
                        if VCManager.shared.profileVC?.toggle == false{
                            UsersManager.shared.initUsersPopUpFromProfile(refresh: true)
                        }

                    }
                })
                self.ref.child("receivedFriendRequests").child(id).observe(.value, with: { (receivedData) in
                                           

                    var receivedFriendRequests:[String] = []
                    if let received = receivedData.value as? [String]{
                        receivedFriendRequests = received
                    }
                    if self.once{
                        self.finishAll["received"] = receivedFriendRequests
                    }else{
                        self.user!.receivedFriendRequests = receivedFriendRequests
                        VCManager.shared.updateRequestsProfileVC()
                    }
                })
                self.ref.child("notifications").child(id).observe( .value, with: { (notificationsData) in
                                                
                    var myNotifications:[Notification] = []
                    if let notificationsDic = notificationsData.value as? [String:Any]{
                        for key in notificationsDic.keys{
                            myNotifications.append(Notification.getNotificationFromDictionary(notificationsDic[key] as! [String:Any]))
                        }
                    }
                    if self.once{
                        self.finishAll["myNotifications"] = myNotifications
                    }else{
                        self.user!.notifications = myNotifications
                    }
                })
                    
                if self.once{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFinishAll(_:)), userInfo: nil, repeats: true)
                }
            })
        }
            
            @objc func didFinishAll(_ timer: Timer){
                //if i add address i need to count 14 keys
                if finishAll.keys.count == 13{
                timer.invalidate()
                once = false
                self.user  = User(id: self.finishAll["id"] as! String, email: self.finishAll["email"] as! String, firstName: self.finishAll["firstName"] as! String, lastName: self.finishAll["lastName"] as! String, dateOfBitrh: self.finishAll["dateOfBirth"] as! Date, friends: self.finishAll["friends"] as! [String], myCart: self.finishAll["myCart"] as! [Treat], sentFriendRequests: self.finishAll["sent"] as! [String], receivedFriendRequests: self.finishAll["received"] as! [String]
                    , myTreats: self.finishAll["myTreats"] as! [Treat], myOrders: self.finishAll["myOrders"] as! [Order], getTreatsStatus: self.finishAll["getTreatStatus"] as! GetTreatStatus, notifications: self.finishAll["myNotifications"] as! [Notification], address: self.finishAll["address"] as? [String : String])
            
                
                 
                        if asNavigation!{
                            //                                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                            //                                        vc.show(shopsVC, sender: nil)
                            
                            let controller = vc as! ViewController
                            controller.performSegue(withIdentifier: "loginToShops", sender: nil)
                            
                        } else {
                            let controller = vc as! SplashScreen
                            controller.performSegue(withIdentifier: "toShops", sender: nil)
                        }
                    

                
                
                }
        }
                    
        }
    
                    
                    
//                                               let rememberRequest = self.get()?.receivedFriendRequests.count ?? receivedFriendRequests.count
//                                            let rememberFriends = self.get()?.friends.count ?? friends.count
//                                                    let rememberSent = self.get()?.sentFriendRequests.count ?? sentFriendRequests.count
//                                        self.user  = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myCart: myCart, sentFriendRequests: sentFriendRequests, receivedFriendRequests: receivedFriendRequests
//                                            , myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus, notifications: myNotifications, address: address)
//                                                    if ((self.profileVC != nil && receivedFriendRequests.count != rememberRequest) ||
//                                                        (self.profileVC != nil && sentFriendRequests.count != rememberSent) ||
//                                                        (self.profileVC != nil && friends.count != rememberFriends)){
//                                                    if  receivedFriendRequests.count != rememberRequest{
//                                                        UsersManager.shared.initFriendsVC(refresh: true)
//                                                        Toast.show(message: "update", controller: UsersManager.shared.profileVC)
//                                                    }
                                              
//                                                        print("here123")
//                                                    if  receivedFriendRequests.count != rememberRequest{
//
////                                                        UsersManager.shared.initFriendsVC(refresh: true)
//                                                        VCManager.shared.updateRequestsProfileVC()
//                                                    }
//
//                                                    print("here123")
//                                                    if  friends.count != rememberFriends{
////                                                        UsersManager.shared.initFriendsVC(refresh: true)
//                                                        VCManager.shared.updateFriendsProfileVC()
////                                                        if UsersManager.shared.profileVC?.toggle == false{
//                                                        if VCManager.shared.profileVC?.toggle == false{
//                                                            print("i am in it")
//                                                            UsersManager.shared.initUsersPopUpFromProfile(refresh: true)
//                                                        }
//
//                                                        }
//                                                    if sentFriendRequests.count < rememberSent {
////                                                        if UsersManager.shared.profileVC?.toggle == false{
//                                                        if VCManager.shared.profileVC?.toggle == false{
//
//                                                            print("i am in it")
//                                                            UsersManager.shared.initUsersPopUpFromProfile(refresh: true)
//                                                        }
//                                                    }
                
//                                    if once{
//                                    once = !once
//                                        if asNavigation{
//    //                                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
//    //                                        vc.show(shopsVC, sender: nil)
//
//                                            let controller = vc as! ViewController
//                                            controller.performSegue(withIdentifier: "loginToShops", sender: nil)
//
//                                        } else {
//                                            let controller = vc as! SplashScreen
//                                            controller.performSegue(withIdentifier: "toShops", sender: nil)
//                                        }
//                                    }
//                                        })
//
//                                })
//                                })
//
//                })
//
//
//
//
//            })
//        })
//        })
//            })
//        }
//
//    }
