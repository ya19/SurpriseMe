//
//  PopUp.swift
//  SurpriseMe
//
//  Created by hackeru on 14/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
class PopUp {
    static func show(storyBoardName:String , vcIdentifer:String, parent:UIViewController){
        let popUpOverVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: vcIdentifer) //as! RegisterViewController
        parent.addChild(popUpOverVC)
        popUpOverVC.view.frame = parent.view.frame
        parent.view.addSubview(popUpOverVC.view)
        popUpOverVC.didMove(toParent: parent)
    }
    static func show(child:UIViewController , parent:UIViewController){
        
        parent.addChild(child)
        child.view.frame = parent.view.frame
        parent.view.addSubview(child.view)
        child.didMove(toParent: parent)
        child.view.frame.origin.x = child.view.frame.width
        
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .transitionCrossDissolve, animations: {
            child.view.frame.origin.x = 0

        })
        
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

        }
        
        
        
}
}
