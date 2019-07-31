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
    
    func add(friend:String){
        var friends = CurrentUser.shared.get()!.friends
        friends.append(friend)
        if friends.count == 1{
            ref.child("friends").child(CurrentUser.shared.get()!.id).setValue(friends)
        }else{
            ref.child("friends").updateChildValues([CurrentUser.shared.get()!.id:friends])
        }
    }
    
    func removeFriend(at:Int){
        var friends = CurrentUser.shared.get()!.friends
        friends.remove(at: at)
        
       ref.child("friends").updateChildValues([CurrentUser.shared.get()!.id:friends])
    }
    func setGetterFor(treat: Treat, userId: String){
            var newTreat = treat
            newTreat.getter = userId
            ref.child("myCart").child(CurrentUser.shared.get()!.id).child(treat.id).updateChildValues(newTreat.toDB)

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
        print(users)
        for someuser in users{
            var ok = true
            for friend in user.friends{
                if someuser.id == friend || someuser.id == user.id{
                    ok = false
                }
            }
            if ok {
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
    
    
    func fakeData(){
        users.append(User(id: "user1", email: "email@gmail.com" ,firstName: "yarden" ,lastName: "swissa" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user3", email: "email@gmail.com" ,firstName: "shahaf" ,lastName: "tepler" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user4", email: "email@gmail.com" ,firstName: "yair" ,lastName: "frid" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user5", email: "email@gmail.com" ,firstName: "iam" ,lastName: "someone" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user6", email: "email@gmail.com" ,firstName: "daniel" ,lastName: "daniel" ,dateOfBitrh: Date() , friends: [], myCart: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
    }
    
}
