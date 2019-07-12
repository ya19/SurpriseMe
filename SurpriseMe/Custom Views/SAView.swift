//
//  SAView.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 10/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class SAView:UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 25.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 25.0
    }
}
