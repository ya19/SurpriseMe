//
//  ViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class ViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: SATextField!
    
    @IBOutlet weak var passwordTextField: SATextField!
    
    var textFields:[SATextField] = []
    var errorMessages:[UILabel] = []
    
//    let ref = Database.database().reference()
    
    var emailError = UILabel()
    var passwordError = UILabel()
    
    @IBAction func checkEmailValidation(_ sender: SATextField) {
        sender.checkValidationNew(sender: sender, errorLabel: emailError, type: .isEmail)
    }
    
    @IBAction func checkPasswordValidation(_ sender: SATextField) {
        sender.checkValidationNew(sender: sender, errorLabel: passwordError, type: .isPassword)
    }
    
    
    @IBAction func editingChanged(_ sender: SATextField) {
        
        if sender == emailTextField{
            sender.setTextFieldValid(sender: sender, errorLabel: emailError)
        } else if sender == passwordTextField{
            sender.setTextFieldValid(sender: sender, errorLabel: passwordError)
            
        }
    }
    
    
    
    
    
    
    @IBAction func login(_ sender: SAButton) {
        for textField in textFields{
            if textField.text!.isEmpty{
                Toast.show(message: "You didn't fill all the details", controller: self)
                return
            }
            
            if textField == emailTextField{
                textField.checkValidationNew(sender: textField, errorLabel: emailError, type: .isEmail)
            } else if textField == passwordTextField{
                textField.checkValidationNew(sender: textField, errorLabel: passwordError, type: .isPassword)
                
            }
            
            
        }
        
        for errorMessage in errorMessages{
            if errorMessage.text != nil {
                Toast.show(message: "Some of your details are not filled properly", controller: self)
                return
            }
        }
        
        //todo check authentication on firebase
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
            guard let strongSelf = self else {
                return }
            
            guard let user = user, error == nil else {

                strongSelf.handleError(error!)
                return
            }

            print("THIS IS UID!!!! \(user.user.uid)")
            let ref = Database.database().reference()
            
            
            ref.child("users").child(user.user.uid).observe(.value, with: { (datasnapshot) in
                guard let newCurrentUserDic = datasnapshot.value as? [String:Any] else{return}
                print("HELLLLLLLO")
                currentUser = User.getUserFromDictionary(newCurrentUserDic)
                print("NEW USER INIT!!! \(currentUser)")
            })
            
            
            let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
            strongSelf.show(shopsVC, sender: sender)
        
        }
        
    }
    
    
    
    
    

    @IBAction func register(_ sender: UIButton) {

        PopUp.toggle(storyBoardName: "Register", vcIdentifer: "registerPopUp", parent: self,toggle:true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(self.view , imageName: "pure-blue-sky")
        textFields = [emailTextField, passwordTextField]
        errorMessages = [emailError, passwordError]
//        addressError.isHidden = true
//        idError.isHidden = true
        self.view.addSubview(emailError)
        self.view.addSubview(passwordError)
        
        if Auth.auth().currentUser != nil{
            let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
            self.show(shopsVC , sender: nil)
        }
   
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    
}

func setBackground(_ view: UIView , imageName: String){
    let backgroundImageView = UIImageView()
    
    view.addSubview(backgroundImageView)
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    backgroundImageView.image = UIImage.init(named: imageName)
    view.sendSubviewToBack(backgroundImageView)
}
