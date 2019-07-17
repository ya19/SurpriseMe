//
//  SATableView.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class SATableView:UITableView{
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.layer.cornerRadius = 25.0
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 25.0
    }
}
