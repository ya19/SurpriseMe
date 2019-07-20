//
//  ViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
    

    @IBAction func register(_ sender: UIButton) {

        PopUp.toggle(storyBoardName: "Register", vcIdentifer: "registerPopUp", parent: self,toggle:true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(self.view , imageName: "pure-blue-sky")
            }

    
}

func setBackground(_ view: UIView , imageName: String){
    let backgroundImageView = UIImageView()
    
    view.addSubview(backgroundImageView)
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    backgroundImageView.image = UIImage.init(named: imageName)
    view.sendSubviewToBack(backgroundImageView)
}
