//
//  UseTreatViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class UseTreatViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var popUpView: SAView!
    @IBOutlet weak var addressLabel: SATextField!
    
    @IBOutlet weak var streetLabel: SATextField!
    
    @IBOutlet weak var cityLabel: SATextField!
    @IBOutlet weak var idLabel: SATextField!
    private let addressError = UILabel()
    private let idError = UILabel()
    var textFields:[UITextField] = []
    var errorMessages:[UILabel] = []
    @IBOutlet weak var closePopUpBtn: SAButton!
    
    var treat: Treat?
    var delegate : SentVoucherDelegate?
    

    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        clearData()
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func checkValidation(_ sender: SATextField) {
//        if sender.text!.isEmpty{
//            print("IS VALID ??")
//            sender.layer.borderColor = UIColor.red.cgColor
//            sender.backgroundColor = .red
//            setupErrorMessage(textField: sender)
//        }
        
        //todo remember to change it to regex for address if we want. and add in the enum
        sender.checkValidationNew(sender: sender, errorLabel: addressError, type: .isEmail)
        
//        if !sender.checkValidationNew(sender: sender, type: .isEmail){
//            sender.setupErrorMessage(textField: sender , errorLabel : errorMessage, textFieldType: .isEmail)
//        }
        
        
    }
    
    @IBAction func checkIDvalidation(_ sender: SATextField) {
        
        sender.checkValidationNew(sender: sender, errorLabel: idError, type: .isID)
    }
    
    
    
    @IBAction func editingChanged(_ sender: SATextField) {
        
        if sender == addressLabel{
            sender.setTextFieldValid(sender: sender, errorLabel: addressError)
        } else if sender == idLabel{
            sender.setTextFieldValid(sender: sender, errorLabel: idError)

        }
        
    }
    
    
    
    @IBAction func useVoucher(_ sender: UIButton) {
        for textField in textFields{
            if textField.text!.isEmpty{
                Toast.show(message: "You didn't fill all the details", controller: self)
                return
            }
        }
        
        for errorMessage in errorMessages{
            if !errorMessage.text!.isEmpty{
                Toast.show(message: "Some of your details are not filled properly", controller: self)
                return
            }
        }
        
        for i in 0..<currentUser.myTreats.count{
            if treat?.id == currentUser.myTreats[i].id{
//                treat?.treatStatus = TreatStatus.Delivered
//                currentUser.myTreats[i] = treat!
                currentUser.myTreats[i].treatStatus = TreatStatus.Delivered
                delegate?.sentVoucher()
            }
            
            print("\(currentUser.myTreats)")
            
        }
        
        
        self.view.removeFromSuperview()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        textFields = [addressLabel , streetLabel , cityLabel, idLabel]
        errorMessages = [addressError, idError]
        addressError.isHidden = true
        idError.isHidden = true
        self.view.addSubview(addressError)
        self.view.addSubview(idError)

        


        popUpView.backgroundColor = UIColor(patternImage: UIImage(named: "pure-blue-sky")!)
        
        
        // Do any additional setup after loading the view.
        


        
    }
    
    func fillFields(){
        if currentUser.adress != nil{
            
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func clearData(){
        addressLabel.text = nil
        streetLabel.text = nil
        cityLabel.text = nil
        idLabel.text = nil
    }


}

