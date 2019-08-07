//
//  UsersManager.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 19/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase
class UsersManager{
    static let shared = UsersManager()
    
    private var users:[User]
    let ref = Database.database().reference()
    private var currentFriendsNum:Int
    private var currentRequestsNum:Int
    private var NotFriendsUsersNum:Int
    var friends:[User]
    var requests:[User]
    var profileVC:ProfileViewController?
    var notFriendsPopUP:UsersPopUpViewController?
    var notFriends:[User]
    var initFriends:Bool
    var initUsersPopUpNotFriends:Bool
    private init(){
        users = []
        friends = []
        requests = []
        profileVC = nil
        notFriendsPopUP = nil
        currentFriendsNum = 0
        currentRequestsNum = 0
        NotFriendsUsersNum = 0
        notFriends = []
        initFriends = true
        initUsersPopUpNotFriends = true
        //users from the server
//        ref.child("users").observeSingleEvent(of: .value) { (DataSnapshot) in
//            let child = DataSnapshot.value as! [String:Any]
//            for key in child.keys{
//                self.users.append(User.getUserFromDictionary(child[key] as! [String:Any]))
//            }
//        }
//        ref.child("users").observeSingleEvent(of: .childAdded) { (DataSnapshot) in
//                self.users.append(User.getUserFromDictionary(DataSnapshot.value as! [String:Any]))
//
//        }

        //todo remove child
//        fakeData()
    }
    
    func update(users:[User]){
        self.users = users
    }
    
 
    func add(order:Order){
//        CurrentUser.shared!.myOrders.append(order)
        
        ref.child("orders").child(CurrentUser.shared.get()!.id).child(order.id).setValue(order.toDB)
    }
    func deny(friend:String){
        
        //notify both users
        
        var received:[String] = CurrentUser.shared.get()!.receivedFriendRequests
        var remember = -1
        for i in 0..<received.count{
            if received[i] == friend{
                remember = i
            }
        }
        if remember != -1{
        received.remove(at: remember)
        if received.count>0{
            ref.child("receivedFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:received])
        }else{
            ref.child("receivedFriendRequests").child(CurrentUser.shared.get()!.id).removeValue()
        }
        }else{
            print("ERROR 123456")
        }
        
        
        ref.child("sentFriendRequests").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
            var sent:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                sent = requests
            }
            var remember = -1;
            for i in 0..<sent.count{
                if sent[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            if remember != -1{
            sent.remove(at: remember)
            if sent.count > 0 {
                self.ref.child("sentFriendRequests").updateChildValues([friend:sent])
            }else{
                self.ref.child("sentFriendRequests").child(friend).removeValue()
                }}else{
                print("ERROR 123456")

            }
        }
    }
    func add(friend:String){
        
        //notify both users
        
        
       
        // delete the friend id from my (recieved array)
        // delete from the friend (sent array) my id
        
        
        var received:[String] = CurrentUser.shared.get()!.receivedFriendRequests
        var remember = -1
        for i in 0..<received.count{
            if received[i] == friend{
                remember = i
            }
        }
        if remember != -1{
        received.remove(at: remember)
        if received.count>0{
            ref.child("receivedFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:received])
        }else{
            ref.child("receivedFriendRequests").child(CurrentUser.shared.get()!.id).removeValue()
            }}else{
            Toast.show(message: "Friend request has been cancelled by the potential friend", controller: profileVC!)
        }
        
        
        ref.child("sentFriendRequests").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
            var sent:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                sent = requests
            }
            var remember = -1;
            for i in 0..<sent.count{
                if sent[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            if remember != -1{
                
                var friends = CurrentUser.shared.get()!.friends
                friends.append(friend)
                if friends.count == 1{
                    self.ref.child("friends").child(CurrentUser.shared.get()!.id).setValue(friends) { (Error, DatabaseReference) in
                        UsersManager.shared.initFriendsVC(refresh: true)

                    }
                }else{
                    self.ref.child("friends").updateChildValues([CurrentUser.shared.get()!.id : friends]) { (Error, DatabaseReference) in
                        UsersManager.shared.initFriendsVC(refresh: true)

                    }
                }
                
                self.ref.child("friends").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
                    var friends:[String] = []
                    if let array = DataSnapshot.value as? [String]{
                        friends = array
                    }
                    friends.append(CurrentUser.shared.get()!.id)
                    if friends.count == 1{
                        self.ref.child("friends").child(friend).setValue(friends)
                    }else{
                        self.ref.child("friends").updateChildValues([friend:friends])
                    }
                }
                
            sent.remove(at: remember)
            if sent.count > 0 {
                self.ref.child("sentFriendRequests").updateChildValues([friend:sent])
            }else{
                self.ref.child("sentFriendRequests").child(friend).removeValue()
                }}else{
                print("Friend request has been canceled by the potential friend")
                Toast.show(message: "Friend request has been canceled by the potential friend", controller: self.profileVC!)

            }
        }
        
    }
    
    func removeFriend(friendId:String){
        var friends = CurrentUser.shared.get()!.friends
        var rememberI = -1
        for i in 0..<friends.count{
            if friends[i] == friendId{
                rememberI = i
            }
        }
        friends.remove(at: rememberI)
        
        ref.child("friends").updateChildValues([CurrentUser.shared.get()!.id:friends])
        
        ref.child("friends").child(friendId).observeSingleEvent(of: .value) { (DataSnapshot) in
            var friendsArray = DataSnapshot.value as! [String]
            var remember = -1
            for i in 0..<friendsArray.count{
                if friendsArray[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            friendsArray.remove(at: remember)
            if friendsArray.count > 0{
                self.ref.child("friends").updateChildValues([friendId:friendsArray])
            }else{
                self.ref.child("friends").child(friendId).removeValue()
            }
        }
    }
    func setGetterFor(treat: Treat, userId: String){
            var newTreat = treat
            newTreat.getter = userId
            ref.child("myCart").child(CurrentUser.shared.get()!.id).child(treat.id).updateChildValues(newTreat.toDB)

    }
    
    
    func cancelFriendRequest(friendId:String, userCell:UserPopUpCell){
        // delete from the friend id recieved array myself.
        // delete from my sent the friendID
        
        ref.child("receivedFriendRequests").child(friendId).observeSingleEvent(of: .value) { (DataSnapshot) in
            var received:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                received = requests
            }
            var remember = -1;
            for i in 0..<received.count{
                if received[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            if remember != -1{
            received.remove(at: remember)
            if received.count > 0 {
                self.ref.child("receivedFriendRequests").updateChildValues([friendId:received]){ (Error, DatabaseReference) in
                    userCell.didFinishReceived = true
                }
            }else{
                self.ref.child("receivedFriendRequests").child(friendId).removeValue(completionBlock: { (Error, DatabaseReference) in
                    userCell.didFinishReceived = true
                })
                }}else{
                print("error , got to check if friend has been added or canceled")
                userCell.didFinishReceived = true


            }
        }
        
        var sent = CurrentUser.shared.get()!.sentFriendRequests
        var remember = -1
        for i in 0..<sent.count{
            if sent[i] == friendId{
                remember = i
            }
        }
        if remember != -1 {
        sent.remove(at: remember)
        if sent.count>0{
            self.ref.child("sentFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:sent]) { (Error, DatabaseReference) in
                userCell.didFinishSent = true
            }
        }else{
            self.ref.child("sentFriendRequests").child(CurrentUser.shared.get()!.id).removeValue { (Error, DatabaseReference) in
                userCell.didFinishSent = true
            }
            }}else{
            print("error , got to check if friend has been added or canceled")
            userCell.didFinishSent = true

        }
        
        
        
        
        
//        var friendRequests = CurrentUser.shared.get()!.friendRequsts
//        friendRequests.remove(at: at)
//
//        ref.child("friendRequests").updateChildValues([CurrentUser.shared.get()!.id:friendRequests])

    }
    func add(friendRequest:String, userCell:UserPopUpCell){
        let id = friendRequest
        ref.child("receivedFriendRequests").child(id).observeSingleEvent(of: .value) { (DataSnapshot) in
            
            var received:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                received = requests
            }
            received.append(CurrentUser.shared.get()!.id)
            if received.count == 1{
                self.ref.child("receivedFriendRequests").child(id).setValue(received, withCompletionBlock: { (Error, DatabaseReference) in
                    userCell.didFinishReceived = true
                })
            }else{
                self.ref.child("receivedFriendRequests").updateChildValues([id:received], withCompletionBlock: { (Error, DatabaseReference) in
                    userCell.didFinishReceived = true
                })
            }
        }
        var sent = CurrentUser.shared.get()!.sentFriendRequests
        sent.append(friendRequest)
        if sent.count == 1{
            ref.child("sentFriendRequests").child(CurrentUser.shared.get()!.id).setValue(sent, withCompletionBlock: { (Error, DatabaseReference) in
                userCell.didFinishSent = true
            })
        }else{
            ref.child("sentFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:sent], withCompletionBlock: { (Error, DatabaseReference) in
                userCell.didFinishSent = true
            })
        }
        
       
    
    }
    
    
    
    func addToCart(treat: Treat){
        ref.child("myCart").child(CurrentUser.shared.get()!.id).child(treat.id).setValue(treat.toDB)
    }
    func removeFromCart(at: Int,delegate: UIViewController){
        let myDelegate:updateCartDelegate = delegate as! updateCartDelegate
        var myCart = CurrentUser.shared.get()!.myCart
        myCart.remove(at: at)
        var cartToDb:[String:Any] = [:]
        for i in 0..<myCart.count{
            cartToDb["treat\(i+1)"] = myCart[i].toDB
        }
        ref.child("myCart").child(CurrentUser.shared.get()!.id).setValue(cartToDb) { (Error, DatabaseReference) in
            myDelegate.update()
        }
    }
    func add(user:User){
        users.append(user)
    }
    
    func removeUser(at: Int) {
        users.remove(at: at)
    }
    
    func getUsers() -> [User]{
        return users
    }
    
    func getIndex(user:User) -> Int {
        for i in 0..<users.count{
            if user.id == users[i].id {
                return i
            }
        }
        return -1
    }
    
    func add(treat:Treat , to:User){
        for i in 0..<users.count{
            if users[i].id == to.id{
                users[i].myTreats.append(treat)
            }
        }
    }
    
    
    func sendNotification(friendID : String , notificationType : NotificationType , treatID: String?){
        
        var notification = Notification.init(date: nil, id: nil, imageName: nil, sender: CurrentUser.shared.get()!.id, notificationType: notificationType, treatID: treatID)
        
        let key = self.ref.child("notifications").child(friendID).childByAutoId().key! as String
        notification.id = key
        self.ref.child("notifications").child(friendID).child(key).setValue(notification.toDB)
    }
    
    func initUsersPopUpFromProfile(refresh:Bool){
        if initUsersPopUpNotFriends{
            initUsersPopUpNotFriends = false
        notFriends = []
        self.ref.child("users").observeSingleEvent(of: .value) { (usersData) in
            let usersDic = usersData.value as! [String:Any]
            self.NotFriendsUsersNum = usersDic.keys.count - CurrentUser.shared.get()!.friends.count - CurrentUser.shared.get()!.receivedFriendRequests.count - 1
            print(self.NotFriendsUsersNum, "Not friends num")
            for key in usersDic.keys{
                let someuser = User.getUserFromDictionary(usersDic[key] as! [String:Any])
                var ok = true
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
                if ok , someuser.id != CurrentUser.shared.get()!.id {
                    self.notFriends.append(someuser)
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
        print(self.NotFriendsUsersNum, "test notFriends num")
        print(notFriends,"test array")
        
        if notFriends.count == NotFriendsUsersNum{
            timer.invalidate()
            if self.notFriendsPopUP == nil{
                self.notFriendsPopUP = (UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController)
                self.notFriendsPopUP!.users = []
            }
            initUsersPopUpNotFriends = true
            let reloadDelegate:RefreshNotFriendsVC = self.notFriendsPopUP!
            reloadDelegate.reloadMyData(notFriends: self.notFriends)
        }
    }
    @objc func didNotFriendsLoaded(_ timer: Timer){
       
print(self.NotFriendsUsersNum, "test notFriends num")
        print(notFriends,"test array")
        if notFriends.count == NotFriendsUsersNum {
            timer.invalidate()
            if self.notFriendsPopUP == nil{
                self.notFriendsPopUP = (UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "usersPopUp") as! UsersPopUpViewController)
                self.notFriendsPopUP!.users = []
            }
           
            self.notFriendsPopUP!.delegate = self.profileVC
            self.notFriendsPopUP!.users = self.notFriends
            self.notFriendsPopUP!.currentUsers = self.notFriends
            //            userAddedDelegate = usersVC
            //            userAddedDelegate?.reloadMydata()
            initUsersPopUpNotFriends = true
            
            if menu.toggle {
                self.profileVC!.toggle = true
            }
            self.profileVC!.toggle = PopUp.toggle(child: self.notFriendsPopUP!, parent: self.profileVC!,toggle: self.profileVC!.toggle)

            
        }
    }
    
    
    
    
    
    
    func initFriendsVC(refresh:Bool) {
        if initFriends{
            initFriends = false
        self.friends = []
        self.requests = []
        currentRequestsNum = CurrentUser.shared.get()!.receivedFriendRequests.count
        currentFriendsNum = CurrentUser.shared.get()!.friends.count
        print(currentRequestsNum,"requestNum")
        for friendId in CurrentUser.shared.get()!.friends{
            self.ref.child("users").child(friendId).observeSingleEvent(of: .value, with: { (friendData) in
                self.friends.append(User.getUserFromDictionary(friendData.value as! [String:Any]))
            })
        }
        print(requests.count,"requestNum1")

        for friendRequestId in CurrentUser.shared.get()!.receivedFriendRequests{
            print(friendRequestId,"32534654745765756765")
            self.ref.child("users").child(friendRequestId).observeSingleEvent(of: .value, with: { (requestData) in
                
                self.requests.append(User.getUserFromDictionary(requestData.value as! [String:Any]))
                print(self.requests.count,"requestNum3")

            })
            
        }
        if !refresh{
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.didFriendsLoaded(_:)), userInfo: nil, repeats: true)
        }else{
            
            Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.refreshFriends(_:)), userInfo: nil, repeats: true)
        }
        }
        
    }
    @objc func refreshFriends(_ timer: Timer){
        if friends.count == currentFriendsNum , requests.count == currentRequestsNum{
            timer.invalidate()
            if self.profileVC == nil{
                self.profileVC = (UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController)
            }
            let reloadDelegate:RefreshProfileVC = self.profileVC!
            print(self.friends,"MAfriends")
            print(self.requests,"MaREquest")
            initFriends = true
            reloadDelegate.reloadMyData(friends: self.friends,requests: self.requests)
        }
    }
    @objc func didFriendsLoaded(_ timer: Timer){
        
        if friends.count == currentFriendsNum , requests.count == currentRequestsNum{
            timer.invalidate()
            //                    let friendsVC = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "friends") as! FriendsViewController
            
                if self.profileVC == nil{
                    self.profileVC = (UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "profile") as! ProfileViewController)
                }
            
            self.profileVC!.friends = self.friends
            self.profileVC!.requests = self.requests
            initFriends = true
            menu.parent?.navigationController?.pushViewController(self.profileVC!, animated: true)
            menu.removeFromParent()
            
        }
    }
    
    
    func giveTreats(delegate: UIViewController){
        let myDelegate:updateCartDelegate = delegate as! updateCartDelegate
        var treats:[Treat] = []
        var x = 0

        
    
        
        while x < CurrentUser.shared.get()!.myCart.count {

            var treat = CurrentUser.shared.get()!.myCart[x]
            let getter = treat.getter!
            let key = self.ref.child("treats").child(getter).childByAutoId().key! as String
            treat.id = key
            treats.append(treat)
            self.ref.child("treats").child(getter).observeSingleEvent(of: .value) { (treatsData) in
                var myTreats:[Treat] = []
                if let treatsDic = treatsData.value as? [String:Any]{
                    for key in treatsDic.keys{
                        myTreats.append(Treat.getTreatFromDictionary(treatsDic[key] as! [String:Any]))
                    }
                }
                
               
                self.ref.child("treats").child(getter).child(key).setValue(treat.toDB)
                self.sendNotification(friendID: getter, notificationType : .isTreatRequest , treatID: treat.id)
                // make sure i got here after i got the entire orders
           
            }
            x = x + 1
            if x == CurrentUser.shared.get()!.myCart.count{
                let orderId = self.ref.child("orders").child(CurrentUser.shared.get()!.id).childByAutoId().key! as String
                let order = Order(id: orderId, treats: treats, date: Date(), buyer: CurrentUser.shared.get()!.id)
                self.add(order: order)
            }
            }
        
        self.ref.child("myCart").child(CurrentUser.shared.get()!.id).removeValue { (Error, DatabaseReference) in
            myDelegate.update()
        }
        
    
        
        //        for i in 0..<CurrentUser.shared.get()!.myCart.count{
        //            var treat = CurrentUser.shared.get()!.myCart[i]
        //            let getter = treat.getter!
        //
        //            for i in 0..<users.count{
        //                if users[i].id == getter{
        //                    treat.id = "\(users[i].id)_\(users[i].myTreats.count + 1)"
        //                    users[i].myTreats.append(treat)
        //                    treats.append(treat)
        //                    // we got to read updated user from server
        //                }
        //            }
        //            ref.child("treats").child(getter).child(treat.id).setValue(treat.toDB)
        //
        //
        //
        //        }
        
    }
    func getAllButFriends(user:User) -> [User]{
        var usersId:[User] = []
        for someuser in users{
            var ok = true
            for friend in user.friends{
                if someuser.id == friend{
                    ok = false
                }
            }
    
            for received in user.receivedFriendRequests{
                if someuser.id == received{
                    ok = false
                }
            }
            if ok , someuser.id != user.id {
                usersId.append(someuser)
            }
        }

  
        return usersId
    }
    
    func getAllBut(user:User) -> [User]{
        return users.filter({ (item) -> Bool in
            item.id != user.id
        })
    }
    
    
//    func fakeData(){
//        users.append(User(id: "user1", email: "email@gmail.com" ,firstName: "yarden" ,lastName: "swissa" ,dateOfBitrh: Date() , friends: [], myCart: [],myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
//        users.append(User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [], myCart: [], myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
//        users.append(User(id: "user3", email: "email@gmail.com" ,firstName: "shahaf" ,lastName: "tepler" ,dateOfBitrh: Date() , friends: [], myCart: [],myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
//        users.append(User(id: "user4", email: "email@gmail.com" ,firstName: "yair" ,lastName: "frid" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
//        users.append(User(id: "user5", email: "email@gmail.com" ,firstName: "iam" ,lastName: "someone" ,dateOfBitrh: Date() , friends: [], myCart: [], friendRequsts: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
//        users.append(User(id: "user6", email: "email@gmail.com" ,firstName: "daniel" ,lastName: "daniel" ,dateOfBitrh: Date() , friends: [], myCart: [], friendRequsts: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
//    }
    
}
