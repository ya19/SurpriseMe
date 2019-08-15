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
    }
    
    func update(users:[User]){
        self.users = users
    }
    
 
    func add(order:Order){
        
        ref.child("orders").child(CurrentUser.shared.get()!.id).child(order.id).setValue((order.toDB)) { (Error, DatabaseReference) in

            VCManager.shared.initMyTreats(refresh: false , fromCart: true)
        }
        
        
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
                }}
        else{
//            Toast.show(message: "Friend request has been cancelled by the potential friend", controller: profileVC!)
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

                    }
                }else{
                    self.ref.child("friends").updateChildValues([CurrentUser.shared.get()!.id : friends]) { (Error, DatabaseReference) in

                    }
                }
                
                self.ref.child("friends").child(friend).observeSingleEvent(of: .value) { (DataSnapshot) in
                    var friends:[String] = []
                    if let array = DataSnapshot.value as? [String]{
                        friends = array
                    }
                    friends.append(CurrentUser.shared.get()!.id)
                    if friends.count == 1{
                        self.ref.child("friends").child(friend).setValue(friends){ (Error, DatabaseReference) in
                            sent.remove(at: remember)
                            if sent.count > 0 {
                                self.ref.child("sentFriendRequests").updateChildValues([friend:sent])
                            }else{
                                self.ref.child("sentFriendRequests").child(friend).removeValue()
                            }
                            
                        }
                    }else{
                        self.ref.child("friends").updateChildValues([friend:friends]){ (Error, DatabaseReference) in
                        sent.remove(at: remember)
                        if sent.count > 0 {
                            self.ref.child("sentFriendRequests").updateChildValues([friend:sent])
                        }else{
                            self.ref.child("sentFriendRequests").child(friend).removeValue()
                        }
                        }
                    }
                }
                
        }else{
                print("Friend request has been canceled by the potential friend")
//                Toast.show(message: "Friend request has been canceled by the potential friend", controller: self.profileVC!)

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
            if var friendsArray = DataSnapshot.value as? [String]{
            var remember = -1
            for i in 0..<friendsArray.count{
                if friendsArray[i] == CurrentUser.shared.get()!.id{
                    remember = i
                }
            }
            
            if remember != -1 {
            friendsArray.remove(at: remember)
            }
            if friendsArray.count > 0{
                self.ref.child("friends").updateChildValues([friendId:friendsArray])
            }else{
                self.ref.child("friends").child(friendId).removeValue()
            }
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
        VCManager.shared.canInitCart = false
        let key = self.ref.child("myCart").child(CurrentUser.shared.get()!.id).childByAutoId().key!
        var myTreat = treat
        myTreat.id = key
        ref.child("myCart").child(CurrentUser.shared.get()!.id).child(myTreat.id).setValue(myTreat.toDB) { (Error, DatabaseReference) in
            VCManager.shared.canInitCart = true
        }
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
    
    
    func giveTreats(delegate: UIViewController){
        let myDelegate:updateCartDelegate = delegate as! updateCartDelegate
        var treats:[String] = []
//        var x = 0
        var price = 0.0
        
        let orderId = self.ref.child("orders").child(CurrentUser.shared.get()!.id).childByAutoId().key! as String

        
            var usersDic:[String:[String]] = [:]
            for someTreat in CurrentUser.shared.get()!.myCart{
                let key = self.ref.child("allTreats").child(someTreat.getter!).childByAutoId().key! as String
                var treat = someTreat
                treat.id = key
                treat.orderId = orderId
                price = price + treat.product.price
                treats.append(treat.id)
                if usersDic[someTreat.getter!] == nil{
                    usersDic[someTreat.getter!] = []
                }
                usersDic[someTreat.getter!]!.append(treat.id)
           
                self.ref.child("allTreats").child(key).setValue(treat.toDB)
                NotificationManager.shared.sendNotification(friendID: someTreat.getter!  , notificationType : .isTreatRequest , treatID: treat.id)
            
            
            
            }
            
            for key in usersDic.keys{
                self.ref.child("treats").child(key).observeSingleEvent(of: .value) { (treatsData) in
                    var myTreats:[String] = []
                    if let treatsArray = treatsData.value as? [String]{
                        myTreats = treatsArray
                    }
                    for treatId in usersDic[key]!{
                        myTreats.append(treatId)
                    }
                    self.ref.child("treats").child(key).setValue(myTreats)
                }
            }
        
                let order = Order(id: orderId, treats: treats, price: price, date: Date(), buyer: CurrentUser.shared.get()!.id)
                self.add(order: order)
        
        
        self.ref.child("myCart").child(CurrentUser.shared.get()!.id).removeValue { (Error, DatabaseReference) in
            myDelegate.update()
        }
        
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
    
}
