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
    
    func getAllButFriends(user:User) -> [User]{


        let friendsId:Set<User> = Set(user.friends.map{$0})
        var usersId:Set<User> = Set(users.map{$0})

        usersId.subtract(friendsId)
        return Array(usersId)
    }
    
    func fakeData(){
        users.append(User(id: "1", email: "email@gmail.com" ,firstName: "yarden" ,lastName: "swissa" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE))
        users.append(User(id: "2", email: "email@gmail.com" ,firstName: "yossi" ,lastName: "appo" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE))
        users.append(User(id: "3", email: "email@gmail.com" ,firstName: "shahaf" ,lastName: "tepler" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE))
        users.append(User(id: "4", email: "email@gmail.com" ,firstName: "yair" ,lastName: "frid" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE))
        users.append(User(id: "5", email: "email@gmail.com" ,firstName: "iam" ,lastName: "someone" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE))
        users.append(User(id: "6", email: "email@gmail.com" ,firstName: "daniel" ,lastName: "daniel" ,dateOfBitrh: "1/1/2000" , friends: [] ,myTreats: [], myOrders: [], myCart: [] , getTreatsStatus: GetTreatStatus.EVERYONE))
    }
    
}
