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
        let storage = Storage.storage().reference()
        private var user:User?
        let ref = Database.database().reference()
        var finishAll:[String:Any]
        var vc:UIViewController?
        var asNavigation:Bool?
        var treatsCount:Int
        var myTreats:[Treat] = []
        var once = true

        private init(){
          user = nil
            finishAll = [:]
            vc = nil
            asNavigation = nil
            myTreats = []
            treatsCount = 0

        }
        

        func get() -> User?{
            return user
        }
        func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
        }
        
        func configure(_ vc:UIViewController , asNavigation : Bool){
            self.vc = vc
            self.asNavigation = asNavigation
            once = true
            finishAll = [:]
            ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (datasnapshot) in
                let dic = datasnapshot.value as! [String:Any]
                
                let id = dic["id"] as! String

                self.finishAll["id"] = dic["id"] as! String
                self.finishAll["email"] = dic["email"] as! String
                self.finishAll["firstName"] = dic["firstName"] as! String
                self.finishAll["lastName"] = dic["lastName"] as! String
                let myTimeInterval = TimeInterval(dic["dateOfBirth"] as! Double)
                self.finishAll["dateOfBirth"] = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
                self.finishAll["getTreatStatus"] = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)!
//                let address:[String:String]? = nil // write to server and get from server in address list
                self.finishAll["address"] = nil

                self.storage.child(id).downloadURL(completion: { (URL, Error) in
                    if URL != nil{
                        self.getData(from: URL!) { data, response, error in
                            guard let data = data, error == nil else { return }
                         
                            DispatchQueue.main.async() {
                                self.finishAll["image"] = UIImage(data: data)
                            }
                        }
                    }else{
                        self.finishAll["image"] = UIImage(named: "icons8-user")
                    }
                    
                })
                self.ref.child("friends").child(id).observe(.value, with: { (friendsData) in

                    var friends:[String] = []
                        if let friendsArr = friendsData.value as? [String]{
                        friends = friendsArr
                        }
                    if self.once{
                        self.finishAll["friends"] = friends
                    }else{
                        if self.user!.friends.count > friends.count{
                            //refresh sentrequests
                            if VCManager.shared.profileVC?.toggle == false{

                                VCManager.shared.initUsersPopUP(refresh: true, withOutFriends: true,parent: VCManager.shared.profileVC!, cellDelegate: nil)
                            }
                        }
                        
                        
                        self.user!.friends = friends
                        VCManager.shared.updateFriendsProfileVC()
                    }
                })
                self.ref.child("orders").child(id).observe( .value, with: { (ordersData) in

                    var myOrders:[Order] = []
                    if let ordersDic = ordersData.value as? [String:Any]{
                        for key in ordersDic.keys{
                            myOrders.append(Order.getOrderFromDictionary(ordersDic[key] as! [String:Any]))
                        }
                    }
                    
                    myOrders = myOrders.sorted(by: { (o1, o2) -> Bool in
                        return o1.date > o2.date
                    })
                    
                    if self.once{
                        self.finishAll["myOrders"] = myOrders
                    }else{
                        self.user!.myOrders = myOrders
                    }
                })
                self.ref.child("treats").child(id).observe( .value, with: { (treatsData) in
                    var treatsArray:[String] = []
                    self.myTreats = []
                    self.treatsCount = treatsArray.count

                    if let treatsIds = treatsData.value as? [String]{
                        treatsArray = treatsIds
                        self.treatsCount = treatsArray.count

                        print(treatsArray.count,"treatsCounthey")
                        for t in treatsArray{
                            self.ref.child("allTreats").child(t).observeSingleEvent(of: .value, with: { (treatFromId) in
                                self.myTreats.append(Treat.getTreatFromDictionary(treatFromId.value as! [String:Any]))
                            })
                        }

                        
                        }
                    print("hey")
                    Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFinishMyTreats(_:)), userInfo: nil, repeats: true)
                })
                self.ref.child("myCart").child(id).observe(.value, with: { (cartData) in
                                

                    var myCart:[Treat] = []
                    if let cartDic = cartData.value as? [String:Any]{
                        for key in cartDic.keys{
                            myCart.append(Treat.getTreatFromDictionary(cartDic[key] as! [String:Any]))

                        }
                    }
                    
                    myCart = myCart.sorted(by: { (t1, t2) -> Bool in
                        //i can force because it has a date as soon as its been added to the cart and to the server
                        return t1.date! > t2.date!
                    })
                    
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
                            VCManager.shared.initUsersPopUP(refresh: true, withOutFriends: true,parent: VCManager.shared.profileVC!, cellDelegate: nil)
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
                        VCManager.shared.initNotifications(refresh: true, caller: nil)
                    }
                })
                    
                if self.once{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFinishAll(_:)), userInfo: nil, repeats: true)
                }
            })
        }
        
        
        @objc func didFinishMyTreats(_ timer: Timer){
            print("hey1")

            if myTreats.count == treatsCount{
                timer.invalidate()
                if self.once{
                    self.finishAll["myTreats"] = myTreats
                }else{
                    self.user!.myTreats = myTreats
                    print("hey2")

                    VCManager.shared.initMyTreats(refresh: true)

                }
            }
        }
        
            @objc func didFinishAll(_ timer: Timer){
                //if i add address i need to count 14 keys
                if finishAll.keys.count == 14{
                timer.invalidate()
                once = false
                    self.user  = User(id: self.finishAll["id"] as! String, email: self.finishAll["email"] as! String, image: (self.finishAll["image"] as! UIImage), firstName: self.finishAll["firstName"] as! String, lastName: self.finishAll["lastName"] as! String, dateOfBitrh: self.finishAll["dateOfBirth"] as! Date, friends: self.finishAll["friends"] as! [String], myCart: self.finishAll["myCart"] as! [Treat], sentFriendRequests: self.finishAll["sent"] as! [String], receivedFriendRequests: self.finishAll["received"] as! [String]
                    , myTreats: self.finishAll["myTreats"] as! [Treat], myOrders: self.finishAll["myOrders"] as! [Order], getTreatsStatus: self.finishAll["getTreatStatus"] as! GetTreatStatus, notifications: self.finishAll["myNotifications"] as! [Notification], address: self.finishAll["address"] as? [String : String])
            
                
                 
                        if asNavigation!{
                            
                            let controller = vc as! ViewController
                            controller.performSegue(withIdentifier: "loginToShops", sender: nil)
                            
                        } else {
                            let controller = vc as! SplashScreen
                            controller.performSegue(withIdentifier: "toShops", sender: nil)
                        }
                    

                
                
                }
        }
                    
        }
    
                    
                    
