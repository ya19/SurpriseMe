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
        CurrentUser.shared!.myOrders.append(order)
        ref.child("users").child(CurrentUser.shared!.id).updateChildValues(CurrentUser.shared!.toDB)
    }
    
    func add(friend:String){
        CurrentUser.shared!.friends.append(friend)
        ref.child("users").child(CurrentUser.shared!.id).updateChildValues(CurrentUser.shared!.toDB)
    }
    
    func removeFriend(at:Int){
        let friend = CurrentUser.shared!.friends[at]
        CurrentUser.shared!.friends.remove(at: at)
        ref.child("users").child(CurrentUser.shared!.id).child("friends").child(friend).removeValue()
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
    func giveTreats(){

        var treats:[Treat] = []
        for i in 0..<CartManager.shared.treats.count{
            var treat = CartManager.shared.treats[i]
            var getter = treat.getter!
            
            for i in 0..<users.count{
                if users[i].id == getter{
                    treat.id = "\(users[i].id)_\(users[i].myTreats.count + 1)"
                    users[i].myTreats.append(treat)
                    treats.append(treat)
                    
                }
            }
            ref.child("users").child(getter).child("myTreats").child(treat.id).setValue(treat.toDB)
        }
            let order = Order(id: "order\(CurrentUser.shared!.myOrders.count + 1)", treats: treats, date: Date(), buyer: CurrentUser.shared)
            add(order: order)
        CartManager.shared.treats = []
    
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
        users.append(User(id: "user1", email: "email@gmail.com" ,firstName: "yarden" ,lastName: "swissa" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user3", email: "email@gmail.com" ,firstName: "shahaf" ,lastName: "tepler" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user4", email: "email@gmail.com" ,firstName: "yair" ,lastName: "frid" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [],  getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user5", email: "email@gmail.com" ,firstName: "iam" ,lastName: "someone" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
        users.append(User(id: "user6", email: "email@gmail.com" ,firstName: "daniel" ,lastName: "daniel" ,dateOfBitrh: Date() , friends: [] ,myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus.EVERYONE, address: nil))
    }
    
}
