//
//  ViewController.swift
//  popUpPractice
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 surprise. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func register(_ sender: UIButton) {
        let popUpOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"registerPopUp") as! RegisterViewController
        self.addChild(popUpOverVC)
        popUpOverVC.view.frame = self.view.frame
        self.view.addSubview(popUpOverVC.view)
        popUpOverVC.didMove(toParent: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

