//
//  FriendTableCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 18/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class FriendTableCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(user: User){
        userImage.image = UIImage.init(named: "icons8-user")
        userNameLabel.text = user.fullName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
