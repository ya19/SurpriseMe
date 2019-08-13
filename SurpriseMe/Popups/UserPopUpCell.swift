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
    var friendAdd:Bool?
    var friend:User?
    var didFinishReceived = true
    var didFinishSent = true
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var friendAddBtn: SAButton!
    @IBAction func friendAddToggle(_ sender: SAButton) {
        // changing the bool
        
        if didFinishSent , didFinishReceived{
        didFinishReceived = false
        didFinishSent = false
        friendAdd! = !friendAdd!
        if friendAdd!{
            // add request
            UsersManager.shared.add(friendRequest: friend!.id,userCell: self)
            NotificationManager.shared.sendNotification(friendID: friend!.id, notificationType: .isFriendRequest, treatID: nil)
            friendAddBtn.setImage(UIImage(named: "icons8-cancel"), for: .normal)
        }else{
            // cancel request
            
            //todo remove notification!!!!!!
            UsersManager.shared.cancelFriendRequest(friendId: friend!.id,userCell: self)
            friendAddBtn.setImage(UIImage(named: "icons8-add"), for: .normal)
            
        }
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populate(user: User){
//        fullName.text = "\(user.firstName) \(user.lastName)"
        fullName.text = user.fullName
        userImage.image = user.image!.circleMasked
    }
    func populate(user: User,friendAdd:Bool){
        friendAddBtn.isHidden = false
        fullName.text = user.fullName
        userImage.image = user.image!.circleMasked
        friend = user
        self.friendAdd = friendAdd
        if friendAdd{
            friendAddBtn.setImage(UIImage(named: "icons8-cancel"), for: .normal)
        }else{
            friendAddBtn.setImage(UIImage(named: "icons8-add"), for: .normal)

        }
    }
}
