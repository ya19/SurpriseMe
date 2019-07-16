//
//  CartProductTableViewCell.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 12/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class CartProductTableViewCell: UITableViewCell {
    var treat:Treat?
    @IBAction func addUser(_ sender: UIButton) {
        delegate?.addUserTapped(cell:self)
        
    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var getterName: UILabel!
    
    
    var delegate:AddUserDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        initCell()
        // Configure the view for the selected state
    }
    
    func populate(treat: Treat){
        productImage.image = treat.product.image
        productName.text = treat.product.name
        productPrice.text = "Price: \(treat.product.price)"
        if let getter = treat.getter {
            getterName.text = "\(getter.firstName ) \(getter.lastName)"

        }
    }
}

extension CartProductTableViewCell:deliverUserDelegate{
    func deliver(user: User) {
        self.treat!.getter = user
        getterName.text = "\(user.firstName) \(user.lastName)"
        for i in 0..<CartManager.shared.treats.count{
            if(CartManager.shared.treats[i].id == self.treat!.id){
                CartManager.shared.treats[i].getter = user
          
            }
            print(self.treat!.id)
            print(CartManager.shared.treats[i].id)
        }
       

    }
}
protocol deliverUserDelegate{
    func deliver(user:User)
}
