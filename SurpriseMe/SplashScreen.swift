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
        let ref = Database.database().reference()

        ref.child("users").observe(.value) { (DataSnapshot) in
            self.readShops()
            if let child = DataSnapshot.value as? [String:Any]{
            var users:[User] = []
            for key in child.keys{
               users.append(User.getUserFromDictionary(child[key] as! [String:Any]))
            }
            
            UsersManager.shared.update(users: users)
            }

            
        }
        ///(       }

        // Do any additional setup after loading the view.
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
                
                //todo if loginAutomatically, do:
                
                
                if Auth.auth().currentUser != nil{
                    if self.fetchFromCoreData(){
                    
                    //init currentuser
                    CurrentUser.shared.configure(self, asNavigation: false)
                    } else{
                        self.performSegue(withIdentifier: "login", sender: nil)
                    }
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        guard let loginVC = segue.destination as? ViewController else {return}
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
