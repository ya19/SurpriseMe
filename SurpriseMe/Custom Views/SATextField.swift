//
//  SATextField.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class SATextField : UITextField{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    func setupTextField(){
        tintColor = .white
        textColor = .darkGray
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        autocorrectionType = .no
        layer.cornerRadius = 25.0
        clipsToBounds = true
        
        let placeholder = self.placeholder != nil ? self.placeholder! : ""
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView = indentView
        leftViewMode = .always
    }
}
