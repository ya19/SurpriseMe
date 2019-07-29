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
    
    private let ref = Database.database().reference()
    private init(){
      user = nil

    }
    
    
    
    func get() -> User?{
        return user
    }
    func configure(_ vc:UIViewController){
        ref.child("users").child(Auth.auth().currentUser!.uid).observe(.value, with: { (datasnapshot) in
            
            let dic = datasnapshot.value as! [String:Any]
            
            let id = dic["id"] as! String
            let email = dic["email"] as! String
            let firstName = dic["firstName"] as! String
            let lastName = dic["lastName"] as! String
            let myTimeInterval = TimeInterval(dic["dateOfBirth"] as! Double)
            let dateOfBirth = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
            let getTreatStatus = GetTreatStatus(rawValue: dic["getTreatStatus"] as! Int)!
            var address:[String:String]? = nil // write to server and get from server in address list
            self.ref.child("friends").child(id).observeSingleEvent(of: .value, with: { (friendsData) in
                var friends:[String] = []
                if let friendsArr = friendsData.value as? [String]{
                    friends = friendsArr
                }
                self.ref.child("orders").child(id).observeSingleEvent(of: .value, with: { (ordersData) in
                    let ordersDic = ordersData.value as! [String:Any]
                    var myOrders:[Order] = []
                    for key in ordersDic.keys{
                        myOrders.append(Order.getOrderFromDictionary(ordersDic[key] as! [String:Any]))
                    }
                    self.ref.child("treats").child(id).observeSingleEvent(of: .value, with: { (treatsData) in
                        let treatsDic = treatsData.value as! [String:Any]
                        var myTreats:[Treat] = []
                        for key in treatsDic.keys{
                            myTreats.append(Treat.getTreatFromDictionary(treatsDic[key] as! [String:Any]))
                        }
                        
                        self.user  = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus, address: address)
                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                        vc.show(shopsVC, sender: nil)
                        
                    })
                })
            }, withCancel: { (Error) in
                var friends:[String] = []
                self.ref.child("orders").child(id).observeSingleEvent(of: .value, with: { (ordersData) in
                    let ordersDic = ordersData.value as! [String:Any]
                    var myOrders:[Order] = []
                    for key in ordersDic.keys{
                        myOrders.append(Order.getOrderFromDictionary(ordersDic[key] as! [String:Any]))
                    }
                    self.ref.child("treats").child(id).observeSingleEvent(of: .value, with: { (treatsData) in
                        let treatsDic = treatsData.value as! [String:Any]
                        var myTreats:[Treat] = []
                        for key in treatsDic.keys{
                            myTreats.append(Treat.getTreatFromDictionary(treatsDic[key] as! [String:Any]))
                        }
                        
                        self.user  = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus, address: address)
                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                        vc.show(shopsVC, sender: nil)
                        
                    })
                }, withCancel: { (Error) in
                    var myOrders:[Order] = []
                    self.ref.child("treats").child(id).observeSingleEvent(of: .value, with: { (treatsData) in
                        let treatsDic = treatsData.value as! [String:Any]
                        var myTreats:[Treat] = []
                        for key in treatsDic.keys{
                            myTreats.append(Treat.getTreatFromDictionary(treatsDic[key] as! [String:Any]))
                        }
                        
                        self.user  = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus, address: address)
                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                        vc.show(shopsVC, sender: nil)
                        
                    }, withCancel: { (Error) in
                      
                        var myTreats:[Treat] = []
                       
                        
                        self.user  = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBitrh: dateOfBirth, friends: friends, myTreats: myTreats, myOrders: myOrders, getTreatsStatus: getTreatStatus, address: address)
                        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                        vc.show(shopsVC, sender: nil)
                        
                    })

                        
                    })
                })
                
            
            
         
        })
        }

    }


