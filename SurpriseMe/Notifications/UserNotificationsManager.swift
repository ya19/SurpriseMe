//
//  NotificationManager.swift
//  SurpriseMe
//
//  Created by Youval Ella on 03/08/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
import UserNotifications

class UserNotificationManager{
    
    static let shared = UserNotificationManager()
    
    
    private init(){
        
    }
    
    func requestNotificationPermission(with callback : @escaping (Bool)->Void){
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound, .carPlay]) { (granted, error) in
            callback(granted)
        }
        
    }
    
    //user notifications, not regular in the bell.
    func createNotification(with text : String, delay : TimeInterval, attachmentUrl : URL? = nil, notificationType : NotificationType){
        //-Custom sound-, -attachment-, -title-, -subtitle-, -thread id-, userInfo
        
        func request(){
            
            let content = UNMutableNotificationContent()
            
            if let url = attachmentUrl,
                let attach = try? UNNotificationAttachment(identifier: "identifier", url: url, options: nil){
                content.attachments = [attach]
            }
            
            let val = arc4random()%2
            
            content.body = text
            content.badge = 1
            
            //            let soundName = UNNotificationSoundName(rawValue: "horse.wav")
            //            let sound = UNNotificationSound(named: soundName)
            //            content.sound = sound
            //            if let sound = try? UNNotificationSound(named: UNNotificationSoundName(rawValue: )){
            //                content.sound = sound
            //            } else {
            //                content.sound = UNNotificationSound.default
            //            }
            content.title = "\(notificationType.description)"
            content.subtitle = "in SurpriseMe"
            content.threadIdentifier = "\(val)"
            content.userInfo = ["event_id":UUID().uuidString]
            
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error{
                    print(error)
                } else {
                    print("request notification success")
                }
            }
            
        }
        
        self.requestNotificationPermission { (granted) in
            if granted{
                request()
            }
        }
    }
}


