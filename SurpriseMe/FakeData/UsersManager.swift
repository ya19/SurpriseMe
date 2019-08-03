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
    
    private init(){
        users = []
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
        var remember = 0
        for i in 0..<received.count{
            if received[i] == friend{
                remember = i
            }
        }
        received.remove(at: remember)
        if received.count>0{
            ref.child("receivedFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:received])
        }else{
            ref.child("receivedFriendRequests").child(CurrentUser.shared.get()!.id).removeValue()
        }
        
        
        ref.child("sentFriendRequests").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
            var sent:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                sent = requests
            }
            var remember = 0;
            for i in 0..<sent.count{
                if sent[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            sent.remove(at: remember)
            if sent.count > 0 {
                self.ref.child("sentFriendRequests").updateChildValues([friend:sent])
            }else{
                self.ref.child("sentFriendRequests").child(friend).removeValue()
            }
        }
    }
    func add(friend:String, profileVC:ProfileViewController){
        
        //notify both users
        
        
        var friends = CurrentUser.shared.get()!.friends
        friends.append(friend)
        if friends.count == 1{
            ref.child("friends").child(CurrentUser.shared.get()!.id).setValue(friends) { (Error, DatabaseReference) in
                CurrentUser.shared.initFriendsVC(refresh: true, profileVC: profileVC)

            }
        }else{
            ref.child("friends").updateChildValues([CurrentUser.shared.get()!.id : friends]) { (Error, DatabaseReference) in
                CurrentUser.shared.initFriendsVC(refresh: true, profileVC: profileVC)

            }
        }
        
        ref.child("friends").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
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
        // delete the friend id from my (recieved array)
        // delete from the friend (sent array) my id
        
        
        var received:[String] = CurrentUser.shared.get()!.receivedFriendRequests
        var remember = 0
        for i in 0..<received.count{
            if received[i] == friend{
                remember = i
            }
        }
        received.remove(at: remember)
        if received.count>0{
            ref.child("receivedFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:received])
        }else{
            ref.child("receivedFriendRequests").child(CurrentUser.shared.get()!.id).removeValue()
        }
        
        
        ref.child("sentFriendRequests").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
            var sent:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                sent = requests
            }
            var remember = 0;
            for i in 0..<sent.count{
                if sent[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            sent.remove(at: remember)
            if sent.count > 0 {
                self.ref.child("sentFriendRequests").updateChildValues([friend:sent])
            }else{
                self.ref.child("sentFriendRequests").child(friend).removeValue()
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
    
    
    func cancelFriendRequest(friendId:String){
        // delete from the friend id recieved array myself.
        // delete from my sent the friendID
        
        ref.child("receivedFriendRequests").child(friendId).observeSingleEvent(of: .value) { (DataSnapshot) in
            var received:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                received = requests
            }
            var remember = 0;
            for i in 0..<received.count{
                if received[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            received.remove(at: remember)
            if received.count > 0 {
                self.ref.child("receivedFriendRequests").updateChildValues([friendId:received])
            }else{
                self.ref.child("receivedFriendRequests").child(friendId).removeValue()
            }
        }
        
        var sent = CurrentUser.shared.get()!.sentFriendRequests
        var remember = 0
        for i in 0..<sent.count{
            if sent[i] == friendId{
                remember = i
            }
        }
        sent.remove(at: remember)
        if sent.count>0{
            self.ref.child("sentFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:sent])
        }else{
            self.ref.child("sentFriendRequests").child(CurrentUser.shared.get()!.id).removeValue()
        }
        
        
        
        
        
//        var friendRequests = CurrentUser.shared.get()!.friendRequsts
//        friendRequests.remove(at: at)
//
//        ref.child("friendRequests").updateChildValues([CurrentUser.shared.get()!.id:friendRequests])

    }
    func add(friendRequest:String){
        let id = friendRequest
        ref.child("receivedFriendRequests").child(id).observeSingleEvent(of: .value) { (DataSnapshot) in
            
            var received:[String] = []
            if let requests = DataSnapshot.value as? [String]{
                received = requests
            }
            received.append(CurrentUser.shared.get()!.id)
            if received.count == 1{
                self.ref.child("receivedFriendRequests").child(id).setValue(received)
            }else{
                self.ref.child("receivedFriendRequests").updateChildValues([id:received])
            }
        }
        var sent = CurrentUser.shared.get()!.sentFriendRequests
        sent.append(friendRequest)
        if sent.count == 1{
            ref.child("sentFriendRequests").child(CurrentUser.shared.get()!.id).setValue(sent)
        }else{
            ref.child("sentFriendRequests").updateChildValues([CurrentUser.shared.get()!.id:sent])
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
            print(cartToDb)
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
    func giveTreats(delegate: UIViewController){
        let myDelegate:updateCartDelegate = delegate as! updateCartDelegate
        var treats:[Treat] = []
        var x = 0

        print("here \(CurrentUser.shared.get()!.myCart.count)")
        
        var didFinish = false
    
        
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
                
                // make sure i got here after i got the entire orders
           
            }
            x = x + 1
            if x == CurrentUser.shared.get()!.myCart.count{
                let orderId = self.ref.child("orders").child(CurrentUser.shared.get()!.id).childByAutoId().key! as String
                let order = Order(id: orderId, treats: treats, date: Date(), buyer: CurrentUser.shared.get()!.id)
                self.add(order: order)
            }
            print(didFinish)
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
            for sent in user.sentFriendRequests{
                if someuser.id  ==  sent{
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
