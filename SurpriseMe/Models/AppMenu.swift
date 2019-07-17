//
//  AppMenu.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class AppMenu{
    static var shared = AppMenu()
    
    var menu:UIViewController?
    var isExpand = false
    private init(){
    }
    func configure(parent:UIViewController){
        if menu == nil {
            menu = MenuViewController()
            parent.view.insertSubview(menu!.view, at: 0)
            parent.addChild(menu!)
            menu!.didMove(toParent: parent)
        }else{
            menu!.removeFromParent()
            menu!.view.removeFromSuperview()
            parent.view.insertSubview(menu!.view, at: 0)
            parent.addChild(menu!)
            menu!.didMove(toParent: parent)
        }
    }
    func showMenuController(parent:UIViewController , shouldExpand: Bool){
        if shouldExpand{
            //show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                parent.view.frame.origin.x = parent.view.frame.width - 80
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                parent.view.frame.origin.x = 0
            }, completion: nil)
        }
        
    }
    func toggleMenu(parent:UIViewController){
        if !isExpand {
            configure(parent: parent)
        }
        isExpand = !isExpand
        showMenuController(parent: parent, shouldExpand: isExpand)
    }
}
