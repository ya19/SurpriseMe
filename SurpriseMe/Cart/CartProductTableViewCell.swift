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
    var toggle:Bool = true
    @IBAction func addUser(_ sender: UIButton) {
//        delegate?.addUserTapped(cell:self)
        if toggle{
            toggle = false
            VCManager.shared.initUsersPopUP(refresh: false, withOutFriends: false,parent: VCManager.shared.cartVC!,cellDelegate: self)

        }

    }
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var getterName: UILabel!
    
    
    var delegate:AddUserDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func populate(treat: Treat, getter: String){
        self.treat = treat
        productImage.image = treat.product.image
        productName.text = treat.product.name
        productPrice.text = "Price: \(treat.product.price) ₪"
         getterName.text = getter
    }
}

extension CartProductTableViewCell:deliverUserDelegate, CartCellDelegate{
    func deliver(user: User) {
        self.toggle = true
        self.treat!.getter = user.id
        getterName.text = "\(user.fullName)"
        var getters = VCManager.shared.cartVC!.getters
        getters[self.treat!.id] = user.fullName
        VCManager.shared.cartVC?.getters = getters
        print("im here")
        UsersManager.shared.setGetterFor(treat: treat!, userId: user.id)
//        CartManager.shared.treats[self.indexPath!.row].getter = userId
        
    }
    func releaseToggle() {
        self.toggle = true
    }
}
protocol deliverUserDelegate{
    func deliver(user:User)
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
protocol CartCellDelegate {
    func releaseToggle()
}
