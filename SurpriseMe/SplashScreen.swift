//
//  SplashScreen.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 28/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
    
        self.readShops()
    }
    
    func readShops(){
        let ref = Database.database().reference()
            var newShopsFromDB:[[Shop]] = [[],[],[]]
        
            ref.child("shops").observeSingleEvent(of: .value) { (datasnapshot) in
                    for child in datasnapshot.children{
                        let snap = child as! DataSnapshot
                        guard let dic = snap.value as? [String:Any] else {return}

                        let shop = Shop.getShopFromDictionary(dic)
                        newShopsFromDB[shop.category.rawValue].append(shop)
                    }
        
                    ShopsManager.shared.update(shops: newShopsFromDB)
                
                
                
                if Auth.auth().currentUser != nil{                    
                    //init currentuser
                    CurrentUser.shared.configure(self, asNavigation: false)

                } else{
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
        }
        
    }
    
    func fetchFromCoreData()-> Bool{
        var email:String?
        var password:String?
        var loginAutomatically:Bool?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
       request.predicate = NSPredicate(format: "email = %@", Auth.auth().currentUser!.email!)
        request.returnsObjectsAsFaults = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            let result = try context.fetch(request)
            if result.count != 0{
            let userObject = result[0] as! NSManagedObject
                email = userObject.value(forKey: "email") as? String
                password = userObject.value(forKey: "password") as? String
                loginAutomatically = userObject.value(forKey: "loginAutomatically") as? Bool
                
            
            }
            if loginAutomatically != nil{
                return loginAutomatically!}
            else {return false}

            
        } catch {
            
            print("Failed")
        }
        return false
    }

}
