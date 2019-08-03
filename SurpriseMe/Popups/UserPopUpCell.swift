//
//  UserPopUpCell.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 16/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class UserPopUpCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var friendAddBtn: SAButton!
    @IBAction func friendAddToggle(_ sender: SAButton) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(user: User){
//        fullName.text = "\(user.firstName) \(user.lastName)"
        fullName.text = user.fullName
    }
    func populate(user: User,friendAdd:Bool){
        
    }
}
