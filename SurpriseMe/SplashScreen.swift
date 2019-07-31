//
//  SplashScreen.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 28/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

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
                
                if Auth.auth().currentUser != nil{
                    
                    //init currentuser
                    CurrentUser.shared.configure(self, asNavigation: false)
                } else{
                    self.performSegue(withIdentifier: "login", sender: nil)
                }
        }
        
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
