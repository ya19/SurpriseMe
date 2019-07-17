//
//  SASearchBar.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class SASearchBar:UISearchBar{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 25.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 25.0
    }
}
