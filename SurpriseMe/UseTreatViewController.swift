//
//  UseTreatViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 15/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class UseTreatViewController: BaseViewController {
    
    @IBOutlet weak var addressLabel: SATextField!
    
    @IBOutlet weak var streetLabel: SATextField!
    
    @IBOutlet weak var cityLabel: SATextField!
    @IBOutlet weak var idLabel: SATextField!
    
    @IBOutlet weak var closePopUpBtn: SAButton!
    
    
    @IBAction func closePopUp(_ sender: UIButton) {
        clearData()
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func useVoucher(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func clearData(){
        addressLabel.text = nil
        streetLabel.text = nil
        cityLabel.text = nil
        idLabel.text = nil
    }


}
