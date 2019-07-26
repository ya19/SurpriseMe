//
//  UsersManager.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 19/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class UsersManager{
    static let shared = UsersManager()
    
    private var users:[User]
    
    private init(){
        users = []
        //users from the server
        fakeData()
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
    func getAllButFriends(user:User) -> [User]{


        let friendsId:Set<User> = Set(user.friends.map{$0})
        var usersId:Set<User> = Set(users.map{$0})

        usersId.subtract(friendsId)
        return Array(usersId).filter{ (item) -> Bool in
            item.id != user.id
        }
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
