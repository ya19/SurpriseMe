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
            getterName.text = "\(getter)"

        }
    }
}

extension CartProductTableViewCell:deliverUserDelegate{
    func deliver(userId: String) {
        self.treat!.getter = userId
        getterName.text = "\(userId)"
    
        UsersManager.shared.setGetterFor(treat: CurrentUser.shared.get()!.myCart[self.indexPath!.row], userId: userId)
//        CartManager.shared.treats[self.indexPath!.row].getter = userId
        
    }
}
protocol deliverUserDelegate{
    func deliver(userId:String)
}


// granting indexpath of current cell in a tableview cell.
extension UITableViewCell {
    
    var tableView: UITableView? {
        return next(UITableView.self)
    }
    
    var indexPath: IndexPath? {
        return tableView?.indexPath(for: self)
    }
}
extension UIResponder {
    
    func next<T: UIResponder>(_ type: T.Type) -> T? {
        return next as? T ?? next?.next(type)
    }
}
