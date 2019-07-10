//
//  RegisterViewController.swift
//  popUpPractice
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 surprise. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBAction func close(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
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

