//
//  SAView.swift
//  popUpPractice
//
//  Created by hackeru on 10/07/2019.
//  Copyright © 2019 surprise. All rights reserved.
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
