//
//  FriendRequestTableViewCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 01/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var friendRequestDateLabel: UILabel!
    
    @IBAction func acceptFriendRequest(_ sender: UIButton) {
        
        //todo approve request and delete from list
    }
    
    
    @IBAction func declineFriendRequest(_ sender: UIButton) {
        
        //todo decline request and delete from list (in database)
    }
    
    func populate(){
        friendNameLabel.text = "Fake name"
        friendRequestDateLabel.text = "Now"
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
