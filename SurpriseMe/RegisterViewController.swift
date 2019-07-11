//
//  RegisterViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {


    @IBAction func closePopUp(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    @IBOutlet weak var popUpView: SAView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.view.sendSubviewToBack(popUpView)
        setBackground(self.popUpView , imageName: "pure-blue-sky")
        // Do any additional setup after loading the view.
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
