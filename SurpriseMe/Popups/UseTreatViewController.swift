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
                //basically suppose to wait for approval from server and then sending.
//                CurrentUser.shared.get()!.myTreats[i].treatStatus = TreatStatus.Delivered
                
            }
            
        }
        
        
//        for i in 0..<currentUser.myTreats.count{
//            if treat?.id == currentUser.myTreats[i].id{
////                treat?.treatStatus = TreatStatus.Delivered
////                currentUser.myTreats[i] = treat!
//                currentUser.myTreats[i].treatStatus = TreatStatus.Delivered
//                delegate?.sentVoucher()
//            }
        
//            print("\(currentUser.myTreats)")
            
        
//        if saveAdress.isOn == true {
//            updateAddress()
//        }else{
//            currentUser.address = nil
//        }
        
        
        self.view.removeFromSuperview()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [houseNumber , streetLabel , cityLabel, idLabel]
        errorMessages = [houseNumberError, streetError, cityError, idError]
        //        fillFields()            VCManager.shared.profileVC!.editScreenToggle = true

       AppMenu.clearMenu()
        for errorMessage in errorMessages{
            self.view.addSubview(errorMessage)
        }
        

        popUpView.backgroundColor = UIColor(patternImage: UIImage(named: "pure-blue-sky")!)
        
        
    }
    
    //todo save it to core data.
//    func updateAddress(){
//        if currentUser.address == nil{
//            currentUser.address = [:]
//        }
//        currentUser.address!["city"] = cityLabel.text
//        currentUser.address!["street"] = streetLabel.text
//        currentUser.address!["housenumber"] = houseNumber.text
//        currentUser.address!["id"] = idLabel.text
//    }
//    func fillFields(){
//        if currentUser.address != nil{
//            cityLabel.text = currentUser.address!["city"]
//            streetLabel.text = currentUser.address!["street"]
//            houseNumber.text = currentUser.address!["housenumber"]
//            idLabel.text = currentUser.address!["id"]
//            saveAdress.isOn = true
//        }
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func clearData(){
        houseNumber.text = nil
        streetLabel.text = nil
        cityLabel.text = nil
        idLabel.text = nil
    }


}

