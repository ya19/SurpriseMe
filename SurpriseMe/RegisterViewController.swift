//
//  RegisterViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {


    @IBOutlet weak var firstName: SATextField!
    @IBOutlet weak var lastName: SATextField!
    @IBOutlet weak var dateOfBirth: UIDatePicker!
    @IBOutlet weak var email: SATextField!
    @IBOutlet weak var password: SATextField!
    @IBOutlet weak var confirmPassword: SATextField!
    @IBOutlet weak var giftStatus: UISegmentedControl!
    
    private let firstNameError = UILabel()
    private let lastNameError = UILabel()
    private let emailError = UILabel()
    private let passwordError = UILabel()
    private let confirmPasswordError = UILabel()
    private let giftStatusError = UILabel()
    private let dateError = UILabel()
    
    var textFields:[SATextField] = []
    var errorMessages:[UILabel] = []
    
    @IBAction func firstNameValidation(_ sender: SATextField) {
        sender.checkValidationNew(sender: sender, errorLabel: firstNameError, type: .isGeneral)
        
    }
    
    @IBAction func lastNameValidation(_ sender: SATextField) {
        
        sender.checkValidationNew(sender: sender, errorLabel: lastNameError, type: .isGeneral)
    }
    
    @IBAction func emailValidation(_ sender: SATextField) {
        
        sender.checkValidationNew(sender: sender, errorLabel: emailError, type: .isEmail)
    }
    
    
    @IBAction func passwordValidation(_ sender: SATextField) {
        sender.checkValidationNew(sender: sender, errorLabel: passwordError, type: .isPassword)
    }
    
    @IBAction func confirmPasswordValidation(_ sender: SATextField) {
        
        if !sender.text!.isEmpty {
            
            if !(sender.text! == password.text!){
            setupErrorMessageForNonTextFields(sender: sender, errorLabel: confirmPasswordError, message: "Your passwords must be the same")
            }
        } else {
            sender.checkValidationNew(sender: sender, errorLabel: confirmPasswordError, type: .isPassword)
        }
        

    }
    
    @IBAction func editingChanged(_ sender: SATextField) {
        
        switch sender{
        case firstName:
            sender.setTextFieldValid(sender: sender, errorLabel: firstNameError)
        case lastName:
            sender.setTextFieldValid(sender: sender, errorLabel: lastNameError)

        case email:
            sender.setTextFieldValid(sender: sender, errorLabel: emailError)
        case password:
            sender.setTextFieldValid(sender: sender, errorLabel: passwordError)
        case confirmPassword:
            sender.setTextFieldValid(sender: sender, errorLabel: confirmPasswordError)
        
        default:
            return
        }

    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        
        setValid(sender: sender, errorLabel: dateError)
    }
    
    @IBAction func giftStatusChanged(_ sender: UISegmentedControl) {
        
        setValid(sender: sender, errorLabel: giftStatusError)
    }
    
    
    
    
    
    
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        clearData()
        self.view.removeFromSuperview()
    }
    @IBAction func register(_ sender: SAButton) {
        //todo: check text fields and errors again.
        
        for textField in textFields{
            if textField.text!.isEmpty {
                Toast.show(message: "You didn't fill all the details", controller: self)
                return
            }
            
            if textField == email{
                textField.checkValidationNew(sender: textField, errorLabel: emailError, type: .isEmail)
            } else if textField == confirmPassword , textField.text != password.text{
                
                setupErrorMessageForNonTextFields(sender: textField, errorLabel: confirmPasswordError, message: "Your passwords must be the same")
            }
        }
        
        if giftStatus.selectedSegmentIndex == -1 {
            setupErrorMessageForNonTextFields(sender: giftStatus, errorLabel: giftStatusError, message: "You must select the who you accept getting gifts from")
            
            return
        }
        
        //todo: checking on dates.
        if dateOfBirth.date == dateOfBirth.maximumDate{
            
            setupErrorMessageForNonTextFields(sender: dateOfBirth, errorLabel: dateError, message: "You must choose a birthday earlier than 1/1/2000")
            return
        }
        
        for errorMessage in errorMessages{
            if errorMessage.text != nil {
                Toast.show(message: "Some of your details are not filled properly", controller: self)
                return
            }
        }
        
        //todo: check in database if email exists
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            
            guard let user = authResult?.user, error == nil else {
//                Toast.show(message: error!.localizedDescription, controller: self)
                self.handleError(error!)
                return
            }
            
            
            let ref = Database.database().reference()
            
            let newUser = User.init(id: user.uid, email: user.email!, firstName: self.firstName.text!, lastName: self.lastName.text!, dateOfBitrh: self.dateOfBirth.date, friends: [], myCart: [], sentFriendRequests: [], receivedFriendRequests: [],  myTreats: [], myOrders: [], getTreatsStatus: GetTreatStatus(rawValue: self.giftStatus!.selectedSegmentIndex)!, notifications: [], address: [:])
            
            ref.child("users").child(user.uid).setValue(newUser.toDB)
            self.view.removeFromSuperview()
            Toast.show(message: "\(user.email!) created successfully", controller: self.parent!)
        
        }
    
}
        
        
        //todo: add to database if successful
        
        
    
    
    @IBOutlet weak var popUpView: SAView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.sendSubviewToBack(popUpView)
        popUpView.backgroundColor = UIColor(patternImage: UIImage(named: "pure-blue-sky")!)
        dateOfBirth.maximumDate = dateOfBirth.date
        dateOfBirth.setValue(UIColor.white, forKey: "textColor")
        
        textFields = [firstName , lastName , email, password , confirmPassword]
        errorMessages = [firstNameError, lastNameError , dateError , emailError , passwordError, confirmPasswordError, giftStatusError]
        
        for errorMessage in errorMessages {
            self.view.addSubview(errorMessage)
        }
        
        
        
        
        
        
//        setBackground(self.popUpView , imageName: "pure-blue-sky")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func clearData(){
        firstName.text = nil
        lastName.text = nil
        dateOfBirth.setDate(Date(), animated: false)
        email.text = nil
        password.text = nil
        confirmPassword.text = nil
        giftStatus.isSelected = false
    }
    
    
    //consider use extension for this method.
    func setupErrorMessageForNonTextFields(sender : UIView , errorLabel : UILabel, message: String) {
        
        
//        print("------>This is from THE NON Textfields setuperror function<------")
        sender.layer.borderColor = UIColor.red.cgColor

        errorLabel.font = errorLabel.font.withSize(12)
        errorLabel.isHidden = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = message
        
        errorLabel.textColor = .red

        
        
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: sender.leadingAnchor , constant: 16),
            errorLabel.topAnchor.constraint(equalTo: sender.bottomAnchor, constant: 4)
            ])
    }
    
    func setValid(sender : UIView, errorLabel : UILabel){
        sender.layer.borderColor = UIColor.blue.cgColor
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "This e-mail address already exists, Please use a different e-mail address."
        case .userNotFound:
            return "This e-mail address does not exists, Please try again."
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
//            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
