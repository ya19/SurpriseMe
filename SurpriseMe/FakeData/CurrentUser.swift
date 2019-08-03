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
    private var currentFriendsNum:Int
    private var currentRequestsNum:Int
    var friends:[User]
    var requests:[User]
    var profileVC:ProfileViewController?
    private init(){
      user = nil
        friends = []
        requests = []
        profileVC = nil
        currentFriendsNum = 0
        currentRequestsNum = 0
    }
    
    func initFriendsVC(refresh:Bool, profileVC:ProfileViewController?) {
       self.profileVC = profileVC
        friends = []
        requests = []
        currentRequestsNum = CurrentUser.shared.get()!.receivedFriendRequests.count
        currentFriendsNum = CurrentUser.shared.get()!.friends.count
            for friendId in CurrentUser.shared.get()!.friends{
                self.ref.child("users").child(friendId).observeSingleEvent(of: .value, with: { (friendData) in
                    self.friends.append(User.getUserFromDictionary(friendData.value as! [String:Any]))
                })
        }
        
        for friendRequestId in CurrentUser.shared.get()!.receivedFriendRequests{
            self.ref.child("users").child(friendRequestId).observeSingleEvent(of: .value, with: { (requestData) in

                self.requests.append(User.getUserFromDictionary(requestData.value as! [String:Any]))
            })

        }
        if !refresh{
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFriendsLoaded(_:)), userInfo: nil, repeats: true)
        }else{
            
                Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshFriends(_:)), userInfo: nil, repeats: true)
        }
        
    }
    @objc func refreshFriends(_ timer: Timer){
        if friends.count == currentFriendsNum , requests.count == currentRequestsNum{
            timer.invalidate()
          
            let reloadDelegate:RefreshProfileVC = profileVC!
            reloadDelegate.reloadMyData(friends: self.friends,requests: self.requests)
        }
    }
    @objc func didFriendsLoaded(_ timer: Timer){
        print(friends.count , "-" , currentFriendsNum, "$$$" , requests.count , "-" , currentRequestsNum)
        
        if friends.count == currentFriendsNum , requests.count == currentRequestsNum{
            timer.invalidate()
//                    let friendsVC = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "friends") as! FriendsViewController
    
            let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController
            
            //profile view controller
//                    friendsVC.friends = self.friends
                    profileVC.friends = self.friends
                    profileVC.requests = self.requests
            
                    menu.parent?.navigationController?.pushViewController(profileVC, animated: true)
            menu.removeFromParent()

        }
    }
    func get() -> User?{
        return user
    }
    func configure(_ vc:UIViewController , asNavigation : Bool){
        var once = true
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (datasnapshot) in
            let dic = datasnapshot.value as! [String:Any]
            
            let id = dic["id"] as! String
            let email = dic["email"] as! String
            let firstName = dic["firstName"] as! String
            let lastName = dic["lastName"] as! String
            let myTimeInterval = TimeInterval(dic["dateOfBirth"] as! Double)
            let dateOfBirth = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
            let getTreatStatus = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)!
            let address:[String:String]? = nil // write to server and get from server in address list
            

            
            self.ref.child("friends").child(id).observe(.value, with: { (friendsData) in

                var friends:[String] = []
                    if let friendsArr = friendsData.value as? [String]{
//                        self.delegate?.doneReadingFriends()
                    friends = friendsArr // todo check if it works.
                    }
                self.ref.child("orders").child(id).observe( .value, with: { (ordersData) in

                    var myOrders:[Order] = []
                    if let ordersDic = ordersData.value as? [String:Any]{
                        for key in ordersDic.keys{
                            myOrders.append(Order.getOrderFromDictionary(ordersDic[key] as! [String:Any]))
                        }
                    }
                    self.ref.child("treats").child(id).observe( .value, with: { (treatsData) in
  
                        var myTreats:[Treat] = []
                        if let treatsDic = treatsData.value as? [String:Any]{
                            for key in treatsDic.keys{
                                myTreats.append(Treat.getTreatFromDictionary(treatsDic[key] as! [String:Any]))
                            }
                        }
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
                                self.ref.child("sentFriendRequests").child(id).observe(.value, with: { (sentData) in
                                    

                                    var sentFriendRequests:[String] = []
                                    if let sent = sentData.value as? [String]{
                                        sentFriendRequests = sent
                                    }
                                    self.ref.child("receivedFriendRequests").child(id).observe(.value, with: { (receivedData) in
                                       

                                        var receivedFriendRequests:[String] = []
                                        if let received = receivedData.value as? [String]{
                                            receivedFriendRequests = received
                                        }
                                    self.user  = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myCart: myCart, sentFriendRequests: sentFriendRequests, receivedFriendRequests: receivedFriendRequests
                                    , myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus, address: address)
                                if once{
                                once = !once
                                    if asNavigation{
//                                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
//                                        vc.show(shopsVC, sender: nil)
                                        
                                        let controller = vc as! ViewController
                                        controller.performSegue(withIdentifier: "loginToShops", sender: nil)
                                        
                                    } else {
                                        let controller = vc as! SplashScreen
                                        controller.performSegue(withIdentifier: "toShops", sender: nil)
                                    }
                                }
                                    })

                            })
                            })

            })
            
        
            
            
        })
    })
    })
    }

}
