//
//  NewFriendTableCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 01/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class NewFriendTableCell: UITableViewCell {

    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var friendImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    //todo get user details of friend
    func populate(user: User){
        friendName.text = user.fullName
        friendImage.image = #imageLiteral(resourceName: "icons8-user")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
