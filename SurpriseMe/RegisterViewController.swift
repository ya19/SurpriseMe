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
    var newFirstName : String = ""
    var newLastName : String = ""
    var boxesChangedArray:[String] = []
    var newEmail : String = ""
    var newPassword : String?
    var newSelectedGiftStatus : Int?
    var emailChange = false
    var passwordChange:Bool?
    var fromRegisterButton: Bool = true
    let ref = Database.database().reference()
    @IBOutlet weak var registerBtn: SAButton!
    
    
    @IBOutlet weak var saveChangesBtn: SAButton!
    var toggle = true
    
    
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
        
//        self.view.removeFromSuperview()
        PopUp.remove(controller: self)
        
        //it works but it looks like it happens simultaneously and not after.
        //tried animation but it won't work.
        if let parent = parent as? ProfileViewController{
            parent.navigationController?.navigationBar.isHidden = false
            
        }
//        toggle = PopUp.toggle(child: self, parent: parent!, toggle: toggle)
        
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

        let today = Date()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let age = gregorian.components([.year], from: dateOfBirth.date, to: today, options: [])

        if age.year! < 18 {
            // user is under 18
            setupErrorMessageForNonTextFields(sender: dateOfBirth, errorLabel: dateError, message: "You must be over 18 to use SurpriseMe! Sorry.")
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
   
    @IBAction func saveChanges(_ sender: SAButton) {


        //1) check for changes, if no changes , close pop up everything normal.
        if checkForNoChanges(){
            print("no change!")
            PopUp.remove(controller: self)
            if let parent = parent as? ProfileViewController{
                parent.navigationController?.navigationBar.isHidden = false
            }
            return
        }
        
        //2) if one of the fields is empty (other than password)
        if !checkEmptyFieldsInChanges(){
            print("Some fields were empty")
            return
        }
        
        //3) check again for age if anything changed. if not, return to last date of birth.
        if  !checkAge(){
            print("age problem")
            dateOfBirth.setDate(CurrentUser.shared.get()!.dateOfBitrh, animated: true)
        } else {
            if dateOfBirth.date != CurrentUser.shared.get()!.dateOfBitrh{
            boxesChangedArray.append("Date Of Birth")
            }
        }
        
        //4) check for changes for each box.
        
        if firstName.text != CurrentUser.shared.get()!.firstName{
            newFirstName = firstName.text!
            boxesChangedArray.append("First name")

            print("firstName changed")
        } else {
            newFirstName = CurrentUser.shared.get()!.firstName
        }
        
        if lastName.text != CurrentUser.shared.get()!.lastName{
            newLastName = lastName.text!
            boxesChangedArray.append("Last name")

            print("lastName changed")

        } else {
            newLastName = CurrentUser.shared.get()!.lastName
        }
        
        if email.text != Auth.auth().currentUser!.email{
            Auth.auth().currentUser?.updateEmail(to: email.text!, completion: { (error) in
                if error != nil{
                    self.handleError(error!)
                    self.emailChange = false
                    self.newEmail = CurrentUser.shared.get()!.email
                    return
                } else{
                    
                    self.emailChange = true
                    self.newEmail = self.email.text!
                    self.boxesChangedArray.append("Email")

                    print("email changed")

                    //
                    
                }
            })
        }
        
        if !(password.text!.isEmpty) , (confirmPassword.text!.isEmpty) {
        Auth.auth().currentUser?.updateEmail(to: email.text!, completion: { (error) in
            if error != nil{
                Toast.show(message: error!.localizedDescription, controller: self)
                self.handleError(error!)
                self.passwordChange = false
                return

            }
            
            self.boxesChangedArray.append("Password")

        })
        }
        
        if giftStatus.selectedSegmentIndex != CurrentUser.shared.get()!.getTreatsStatus.rawValue{
            newSelectedGiftStatus = giftStatus.selectedSegmentIndex
            boxesChangedArray.append("Accepting Gifts from")

        } else {
            newSelectedGiftStatus = CurrentUser.shared.get()!.getTreatsStatus.rawValue
        }
        
        
        //alert here are the chages. approve? OK cool, cancel no change.
        var changedBoxes:String = ""

        if boxesChangedArray.count > 0{
        for change in boxesChangedArray{
           changedBoxes.append(" \(change)")
        }
            
            let alert = UIAlertController(title: "You have made some changes!", message: "You have changed your \(changedBoxes) do you approve these changes?", preferredStyle: .alert)
            
            let alertApprove = UIAlertAction(title: "OK", style: .default) { (action) in
                let user = User.init(id: CurrentUser.shared.get()!.id, email: self.newEmail, firstName: self.newFirstName, lastName: self.newLastName, dateOfBitrh: self.dateOfBirth.date, friends: CurrentUser.shared.get()!.friends, myCart: CurrentUser.shared.get()!.myCart, sentFriendRequests: CurrentUser.shared.get()!.sentFriendRequests, receivedFriendRequests: CurrentUser.shared.get()!.receivedFriendRequests, myTreats: CurrentUser.shared.get()!.myTreats, myOrders: CurrentUser.shared.get()!.myOrders, getTreatsStatus: GetTreatStatus(rawValue: self.newSelectedGiftStatus!)!, notifications: CurrentUser.shared.get()!.notifications, address: CurrentUser.shared.get()?.address)
                self.ref.child("users").child(CurrentUser.shared.get()!.id).updateChildValues(user.toDB)
                
                Toast.show(message: "Your details had been updated successfully!", controller: self.parent!)
                PopUp.remove(controller: self)
                if let parent = self.parent as? ProfileViewController{
                    parent.navigationController?.navigationBar.isHidden = false
                    parent.nameLabel.text = user.fullName
                }
            }
            
            let cancelAlert = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
                Toast.show(message: "No changes!", controller: self.parent!)
                PopUp.remove(controller: self)
                if let parent = self.parent as? ProfileViewController{
                    parent.navigationController?.navigationBar.isHidden = false
                }
            }
            
            alert.addAction(alertApprove)
            alert.addAction(cancelAlert)
            self.present(alert, animated: true)
        } else {
            Toast.show(message: "No changes!", controller: self.parent!)
            PopUp.remove(controller: self)
            if let parent = self.parent as? ProfileViewController{
                parent.navigationController?.navigationBar.isHidden = false
            }
        }
//
//        let user = User.init(id: CurrentUser.shared.get()!.id, email: newEmail, firstName: newFirstName, lastName: newLastName, dateOfBitrh: dateOfBirth.date, friends: CurrentUser.shared.get()!.friends, myCart: CurrentUser.shared.get()!.myCart, sentFriendRequests: CurrentUser.shared.get()!.sentFriendRequests, receivedFriendRequests: CurrentUser.shared.get()!.receivedFriendRequests, myTreats: CurrentUser.shared.get()!.myTreats, myOrders: CurrentUser.shared.get()!.myOrders, getTreatsStatus: GetTreatStatus(rawValue: newSelectedGiftStatus!)!, notifications: CurrentUser.shared.get()!.notifications, address: CurrentUser.shared.get()?.address)
        

        
        

        
        //no need to check for empty cause they are already filled
        
//        //check for empty text fields
//        if checkEmptyFields(){
//            if checkAge(){
//                if checkPasswordValidation(){
//                    if checkErrors(){
//                        if checkForEmailChange() , checkForPasswordChange(){
//                            setUpdates(isNewEmail : true , isNewPass: true)
//                        } else if checkForEmailChange() , !checkForPasswordChange() {
//                            setUpdates(isNewEmail : true , isNewPass: false)
//                        } else if checkForPasswordChange(), !checkForEmailChange(){
//                            setUpdates(isNewEmail : false, isNewPass: true)
//                        } else {
//                            setUpdates(isNewEmail : false , isNewPass: false)
//
////                            return
//                        }
//                    }
//                }
//            } else {
//                dateOfBirth.setDate(CurrentUser.shared.get()!.dateOfBitrh, animated: true)
//                if checkPasswordValidation(){
//                    if checkErrors(){
//                        if checkForEmailChange() , checkForPasswordChange(){
//                            setUpdates(isNewEmail : false , isNewPass: false)
////                            PopUp.remove(controller: self)
//                            self.view.removeFromSuperview()
//
//                        } else {
//                            return
//                        }
//                    }
//                }
//            }
//        }
//
//
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }
    
    func setUpdates(isNewEmail : Bool , isNewPass: Bool){
        let updatedUser:User?
        
        
        if isNewEmail , isNewPass{
                updatedUser = User.init(id: CurrentUser.shared.get()!.id, email: newEmail, firstName: firstName.text!, lastName: lastName.text!, dateOfBitrh: dateOfBirth.date, friends: CurrentUser.shared.get()!.friends, myCart: CurrentUser.shared.get()!.myCart, sentFriendRequests: CurrentUser.shared.get()!.sentFriendRequests, receivedFriendRequests: CurrentUser.shared.get()!.receivedFriendRequests, myTreats: CurrentUser.shared.get()!.myTreats, myOrders: CurrentUser.shared.get()!.myOrders, getTreatsStatus: GetTreatStatus(rawValue: giftStatus!.selectedSegmentIndex)!, notifications: CurrentUser.shared.get()!.notifications, address: CurrentUser.shared.get()?.address)
            
            Toast.show(message: "Your email has successfully changed to \(newEmail)", controller: self.parent!)
        } else if isNewEmail , !isNewPass{
                updatedUser = User.init(id: CurrentUser.shared.get()!.id, email: newEmail, firstName: firstName.text!, lastName: lastName.text!, dateOfBitrh: dateOfBirth.date, friends: CurrentUser.shared.get()!.friends, myCart: CurrentUser.shared.get()!.myCart, sentFriendRequests: CurrentUser.shared.get()!.sentFriendRequests, receivedFriendRequests: CurrentUser.shared.get()!.receivedFriendRequests, myTreats: CurrentUser.shared.get()!.myTreats, myOrders: CurrentUser.shared.get()!.myOrders, getTreatsStatus: GetTreatStatus(rawValue: giftStatus!.selectedSegmentIndex)!, notifications: CurrentUser.shared.get()!.notifications, address: CurrentUser.shared.get()?.address)
                        Toast.show(message: "Your email has successfully changed to \(newEmail)", controller: self.parent!)
        }else if isNewPass , !isNewEmail{
            updatedUser = User.init(id: CurrentUser.shared.get()!.id, email: CurrentUser.shared.get()!.email, firstName: firstName.text!, lastName: lastName.text!, dateOfBitrh: dateOfBirth.date, friends: CurrentUser.shared.get()!.friends, myCart: CurrentUser.shared.get()!.myCart, sentFriendRequests: CurrentUser.shared.get()!.sentFriendRequests, receivedFriendRequests: CurrentUser.shared.get()!.receivedFriendRequests, myTreats: CurrentUser.shared.get()!.myTreats, myOrders: CurrentUser.shared.get()!.myOrders, getTreatsStatus: GetTreatStatus(rawValue: giftStatus!.selectedSegmentIndex)!, notifications: CurrentUser.shared.get()!.notifications, address: CurrentUser.shared.get()?.address)
            
        } else{
                    updatedUser = User.init(id: CurrentUser.shared.get()!.id, email: CurrentUser.shared.get()!.email, firstName: firstName.text!, lastName: lastName.text!, dateOfBitrh: dateOfBirth.date, friends: CurrentUser.shared.get()!.friends, myCart: CurrentUser.shared.get()!.myCart, sentFriendRequests: CurrentUser.shared.get()!.sentFriendRequests, receivedFriendRequests: CurrentUser.shared.get()!.receivedFriendRequests, myTreats: CurrentUser.shared.get()!.myTreats, myOrders: CurrentUser.shared.get()!.myOrders, getTreatsStatus: GetTreatStatus(rawValue: giftStatus!.selectedSegmentIndex)!, notifications: CurrentUser.shared.get()!.notifications, address: CurrentUser.shared.get()?.address)
        }
        PopUp.remove(controller: self)
        
        //it works but it looks like it happens simultaneously and not after.
        //tried animation but it won't work.
        if let parent = parent as? ProfileViewController{
            parent.navigationController?.navigationBar.isHidden = false
            
        }
        ref.child("users").child(CurrentUser.shared.get()!.id).updateChildValues(updatedUser!.toDB)
    }
    
    func checkForPasswordChange()->Bool{
            Auth.auth().currentUser?.updateEmail(to: email.text!, completion: { (error) in
                if error != nil{
                    Toast.show(message: error!.localizedDescription, controller: self)
                    self.handleError(error!)
                    self.passwordChange = false
                    return
                } else{
                    
                    self.passwordChange = true
                    self.newPassword = self.password.text
                }
            })
            
            return passwordChange ?? false

    }
    
    func checkForNoChanges()-> Bool{
        if firstName.text == CurrentUser.shared.get()!.firstName ,
            lastName.text == CurrentUser.shared.get()!.lastName,
            email.text == CurrentUser.shared.get()!.email,
            dateOfBirth.date == CurrentUser.shared.get()!.dateOfBitrh,
            password.text!.isEmpty , confirmPassword.text!.isEmpty,
            giftStatus.selectedSegmentIndex == CurrentUser.shared.get()!.getTreatsStatus.rawValue{
            return true
        }
        
        return false
    }

    
    func checkForEmailChange()-> Bool{
        //if email has been changed
        //puting ! cause this button only appear when a current user exist anyway.
        if email.text != Auth.auth().currentUser!.email{
            Auth.auth().currentUser?.updateEmail(to: email.text!, completion: { (error) in
                if error != nil{
                    self.handleError(error!)
                    self.emailChange = false
                    self.newEmail = CurrentUser.shared.get()!.email
                    return
                } else{
                    
                    self.emailChange = true
                    self.newEmail = self.email.text!
                    //
                    //                    self.ref.child("users").child(CurrentUser.shared.get()!.id).child("email").setValue(self.email.text!)
                    //
                    Toast.show(message: "Your email had changed to \(self.email.text!)", controller: self)
                }
            })
            
            return emailChange
        }
        
        return false
    }
    
    
    func checkEmptyFieldsInChanges()-> Bool{
        for textField in textFields{
            if textField.text!.isEmpty , textField != password , textField != confirmPassword{
                Toast.show(message: "You didn't fill all the details", controller: self)
                return false
            }
        }
        return true
    }
    
    func checkAge()-> Bool{
        let today = Date()
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let age = gregorian.components([.year], from: dateOfBirth.date, to: today, options: [])
        
        if age.year! < 18 {
            // user is under 18
            setupErrorMessageForNonTextFields(sender: dateOfBirth, errorLabel: dateError, message: "You must be over 18 to use SurpriseMe! Sorry.")
            return false
        }
        
        return true
    }
    
    func checkErrors()-> Bool{
        //check for errors.
        for errorMessage in errorMessages{
            if errorMessage.text != nil {
                Toast.show(message: "Some of your details are not filled properly", controller: self)
                return false
            }
        }
        
        return true
    }
    
    func checkPasswordValidation()->Bool{
        //if pass not empty , check
        if password.text != nil || confirmPassword.text != nil{
            password.checkValidationNew(sender: password, errorLabel: passwordError, type: .isPassword)
            
            if !confirmPassword.text!.isEmpty {
                
                if !(confirmPassword.text! == password.text!){
                    setupErrorMessageForNonTextFields(sender: confirmPassword, errorLabel: confirmPasswordError, message: "Your passwords must be the same")
                    return false
                }
                return true
            } else {
                confirmPassword.checkValidationNew(sender: confirmPassword, errorLabel: confirmPasswordError, type: .isPassword)
                return false
            }
            return true
        }
        return false
    }
    
    
    
    func readUserFromServer(){
        let user = CurrentUser.shared.get()!
        firstName.text = user.firstName
        lastName.text = user.lastName
        email.text = Auth.auth().currentUser!.email
        dateOfBirth.setDate(user.dateOfBitrh, animated: true)
        giftStatus.selectedSegmentIndex = user.getTreatsStatus.rawValue
        

    }
    
    
//    func readUserFromServer(){
//        guard let id = CurrentUser.shared.get()?.id else{return}
//        ref.child("users").child(id).observeSingleEvent(of: .value) { (DataSnapshot) in
//            let dic = DataSnapshot.value as! [String:Any]
//            let user = User.getUserFromDictionary(dic)
//            self.firstName.text = user.firstName
//            self.lastName.text = user.lastName
//            self.email.text = user.email
//
//            //password...
//
//            self.dateOfBirth.setDate(user.dateOfBitrh, animated: true)
//            self.giftStatus.selectedSegmentIndex = user.getTreatsStatus.rawValue
//            self.existingUser = user
//        }
//
//
//
//    }
    
    func setup(){
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
        
        //might be better to do if let parent instead of hiding etc.
        
        if fromRegisterButton{
            saveChangesBtn.isHidden = true
        } else {
            saveChangesBtn.isHidden = false
            registerBtn.isHidden = true
            
            readUserFromServer()
        }
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
