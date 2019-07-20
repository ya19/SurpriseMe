//
//  PopUp.swift
//  SurpriseMe
//
//  Created by hackeru on 14/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
class PopUp {
    static func toggle(storyBoardName:String , vcIdentifer:String, parent:UIViewController,toggle:Bool) -> Bool{
        if parent.children.count != 0{
            for i in 0 ..< parent.children.count{
                if let _ = parent.children[i] as? MenuViewController{
                    if parent.children.count > 1 {
                        AppMenu.clearMenu()
                    }
                }else{
                      self.remove(controller: parent.children[i])
                }
            }
        }
        
            let popUpOverVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: vcIdentifer) //as! RegisterViewController
        if(toggle){
            parent.addChild(popUpOverVC)
            popUpOverVC.view.frame = parent.view.frame
            parent.view.addSubview(popUpOverVC.view)
            popUpOverVC.didMove(toParent: parent)
        }else{
            self.remove(controller: popUpOverVC)
        }
        
        return !toggle
    }
    static func toggle(child:UIViewController , parent:UIViewController,toggle:Bool) -> Bool{
        if parent.children.count != 0{
            for i in 0 ..< parent.children.count{
                if let _ = parent.children[i] as? MenuViewController{
                    if parent.children.count > 1 {
                        AppMenu.clearMenu()
                    }
                }else{
                    self.remove(controller: parent.children[i])
                }
            }
        }
        if(toggle){
            parent.addChild(child)
            child.view.frame = parent.view.frame
            parent.view.addSubview(child.view)
            child.didMove(toParent: parent)
            child.view.frame.origin.x = child.view.frame.width
        }else{
            self.remove(controller: child)
        }
      
        
        
  
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
            child.view.frame.origin.x = 0

        })

        return !toggle

    }
    
    static func remove(controller: UIViewController){
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
//            controller.view.frame.origin.x = controller.view.frame.width - 50
//            controller.view.removeFromSuperview()
//
//        }
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
            controller.view.frame.origin.x = controller.view.frame.width
        }) { (true) in
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
        
        
        
}
}
