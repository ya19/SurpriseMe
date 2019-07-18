//
//  RegisterViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {


    @IBOutlet weak var firstName: SATextField!
    @IBOutlet weak var lastName: SATextField!
    @IBOutlet weak var dateOfBirth: UIDatePicker!
    @IBOutlet weak var email: SATextField!
    @IBOutlet weak var password: SATextField!
    @IBOutlet weak var confirmPassword: SATextField!
    @IBOutlet weak var giftStatus: UISegmentedControl!
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        clearData()
        self.view.removeFromSuperview()
    }
    @IBAction func register(_ sender: SAButton) {
        self.view.removeFromSuperview()
    }
    @IBOutlet weak var popUpView: SAView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.sendSubviewToBack(popUpView)
        popUpView.backgroundColor = UIColor(patternImage: UIImage(named: "pure-blue-sky")!)
        dateOfBirth.maximumDate = Date()
        dateOfBirth.setValue(UIColor.white, forKey: "textColor")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
