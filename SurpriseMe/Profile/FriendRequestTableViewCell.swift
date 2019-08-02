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
    
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBAction func acceptFriendRequest(_ sender: UIButton) {
        
        //todo approve request and delete from list
    }
    
    
    @IBAction func declineFriendRequest(_ sender: UIButton) {
        
        //todo decline request and delete from list (in database)
    }
    
    //todo: parameter friend request.
    func populate(){
        friendNameLabel.text = "Fake name"
        friendRequestDateLabel.text = "Now"
        friendImage.image = #imageLiteral(resourceName: "icons8-user").circleMasked
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
