//
//  FriendRequestTableViewCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 01/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    var user:User?
    var delegate:updateList?
    var once = true
    var profileVC:ProfileViewController?
    @IBOutlet weak var friendNameLabel: UILabel!
    
    @IBOutlet weak var friendRequestDateLabel: UILabel!
    
    @IBOutlet weak var friendImage: UIImageView!
    
    @IBAction func acceptFriendRequest(_ sender: UIButton) {
        if once {
            once = false

            UsersManager.shared.add(friend: user!.id)
            
            //send notification for friend that i approved.
            UsersManager.shared.sendNotification(friendID: user!.id, notificationType: .isFriendApproval, treatID: nil)
            
            //delete my notification
            NotificationManager.shared.removeFriendRequestNotification(friendID : user!.id)
            
            
        //todo approve request and delete from list
            delegate?.remove(at: self.indexPath!.row)
            

        }
    }
    
    
    @IBAction func declineFriendRequest(_ sender: UIButton) {
        if once{
            once = false
            UsersManager.shared.deny(friend: user!.id)
            
            UsersManager.shared.sendNotification(friendID: user!.id, notificationType: .isFriendDecline, treatID: nil)
            delegate?.remove(at: self.indexPath!.row)
        }

        //todo decline request and delete from list (in database)
    }
    //todo: parameter friend request.
    func populate(user:User){
        once = true
        friendNameLabel.text = user.fullName
        friendRequestDateLabel.text = "Now"
        friendImage.image = #imageLiteral(resourceName: "icons8-user").circleMasked
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }



}
