//
//  ViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    
    @IBOutlet weak var emailTextField: SATextField!
    
    @IBOutlet weak var passwordTextField: SATextField!
    
    var textFields:[SATextField] = []
    var errorMessages:[UILabel] = []
    
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
    
        
        let shopsVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
        self.navigationController?.pushViewController(shopsVC, animated: true)
        
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
