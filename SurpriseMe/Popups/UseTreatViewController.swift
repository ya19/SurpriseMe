//
//  UseTreatViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import Firebase

class UseTreatViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var popUpView: SAView!

    
    @IBOutlet weak var houseNumber: SATextField!
    @IBOutlet weak var streetLabel: SATextField!
    
    @IBOutlet weak var cityLabel: SATextField!
    @IBOutlet weak var idLabel: SATextField!
    private let houseNumberError = UILabel()
    private let idError = UILabel()
    private let streetError = UILabel()
    private let cityError = UILabel()

    var textFields:[SATextField] = []
    var errorMessages:[UILabel] = []
    @IBOutlet weak var closePopUpBtn: SAButton!
    
    var treat: Treat?
    var delegate : TreatStatusChangedDelegate?
    
    var treats:[Treat]{
        return CurrentUser.shared.get()!.myTreats
    }
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        clearData()
        self.view.removeFromSuperview()
    }
    
    @IBAction func checkHouseNumberValidation(_ sender: SATextField) {
        sender.checkValidationNew(sender: sender, errorLabel: houseNumberError, type: .isGeneral)
    }
    
    @IBAction func checkStreetValidation(_ sender: SATextField) {
        
        sender.checkValidationNew(sender: sender, errorLabel: streetError, type: .isGeneral)
    }
    
    
    @IBAction func checkCityValidation(_ sender: SATextField) {
        
        sender.checkValidationNew(sender: sender, errorLabel: cityError, type: .isGeneral)
    }
    
    
    @IBAction func checkIDvalidation(_ sender: SATextField) {
        
        sender.checkValidationNew(sender: sender, errorLabel: idError, type: .isID)
    }
    
    
    
    @IBAction func editingChanged(_ sender: SATextField) {
        
        switch sender{
        case houseNumber :
            sender.setTextFieldValid(sender: sender, errorLabel: houseNumberError)
        case streetLabel:
            sender.setTextFieldValid(sender: sender, errorLabel: streetError)
        case cityLabel:
            sender.setTextFieldValid(sender: sender, errorLabel: cityError)
        case idLabel:
            sender.setTextFieldValid(sender: sender, errorLabel: idError)
            
        default: return
        }
        

        
    }
    
    
    
    @IBAction func useVoucher(_ sender: UIButton) {
        for textField in textFields{
            if textField.text!.isEmpty{
                Toast.show(message: "You didn't fill all the details", controller: self)
                return
            }
            
            if textField == idLabel{
                textField.checkValidationNew(sender: textField, errorLabel: idError, type: .isID)
            }
        }
        
        for errorMessage in errorMessages{
            if errorMessage.text != nil{
                Toast.show(message: "Some of your details are not filled properly", controller: self)
                return
            }
        }
        
        let ref = Database.database().reference()
        for i in 0..<CurrentUser.shared.get()!.myTreats.count{
            if treat?.id == CurrentUser.shared.get()!.myTreats[i].id{
                
                ref.child("allTreats").child(treat!.id).child("status").setValue(TreatStatus.Delivered.rawValue)
                delegate?.updateStatus(treatID: treat!.id, status: .Delivered)
                
            }
            
        }
        
        self.view.removeFromSuperview()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [houseNumber , streetLabel , cityLabel, idLabel]
        errorMessages = [houseNumberError, streetError, cityError, idError]


       AppMenu.clearMenu()
        for errorMessage in errorMessages{
            self.view.addSubview(errorMessage)
        }
        

        popUpView.backgroundColor = UIColor(patternImage: UIImage(named: "pure-blue-sky")!)
        
        
    }
    
    func clearData(){
        houseNumber.text = nil
        streetLabel.text = nil
        cityLabel.text = nil
        idLabel.text = nil
    }


}

