//
//  VCExtension.swift
//  SurpriseMe
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController{

    override func viewDidLoad() {
        keyboardHandler()
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return .portrait
    }
    
    func keyboardHandler(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    

}

