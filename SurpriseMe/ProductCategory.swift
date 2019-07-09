//
//  ProductCategory.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 08/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

enum ProductCategory:Int , CustomStringConvertible{
    case Shoes = 0, Tshirts
    var description: String{
        switch self{
            case .Shoes:
                return "Shoes"
            case .Tshirts:
                return "T-Shirts"
        }
    }
}
