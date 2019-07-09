//
//  Category.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

enum Category:Int, CustomStringConvertible {
    
    case SPORT = 0, ELECRICTY , CLOTHING
    
    var description: String{
        switch self{
            case .SPORT:
                return "Sport"
            case .ELECRICTY:
                return "Electricty"
            case .CLOTHING:
                return "Clothing"
        }
    }
}
