//
//  AppMenu.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 18/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class AppMenu{
    static var currentItem = 0
    static func toggleMenu(parent: UIViewController){
        menu.toggle = !menu.toggle

        if menu.toggle {
            menu.view.removeFromSuperview()
            PopUp.show(child: menu, parent: parent)
        }else{
            menu.view.removeFromSuperview()
        }

    }
    static func clearMenu(){
        if menu.toggle {
            menu.toggle = !menu.toggle
            menu.view.removeFromSuperview()
        }
    }
}
