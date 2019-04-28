//
//  NotificationManager.swift
//  Noteapp
//
//  Created by Apple on 24/04/19.
//  Copyright © 2019 JP.LLC. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationManager : NSObject{
    
    static let shared:NotificationManager = {
        
        return NotificationManager()
        
    }()
    
    var isAuthorized = false
    
    
    func requestAuthorization(){
        
        let options:UNAuthorizationOptions = [.badge,.alert,.sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted:Bool, error:Error?) in
            if granted{
                
                print("Notification Authorized")
                self.isAuthorized = true
                
            }else{
                
                self.isAuthorized = false
                print("Notification Not Authorized")
                
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    func setReminter(date:Date) ->Date?{
        
        cancelAllNotifcation()
        
        let content = UNMutableNotificationContent()
        content.title = "Knote"
        content.body = "Notification"
        
        guard let filePath = Bundle.main.path(forResource: "banner", ofType: "png") else{
            
            print("Image not found")
            return nil
        }
        
        let attachement = try! UNNotificationAttachment(identifier: "attachement", url: URL.init(fileURLWithPath: filePath), options: nil)
        
       content.attachments = [attachement]
        
        let components = Calendar.current.dateComponents([.minute,.hour], from: date)
        
        var newComponent = DateComponents()
        newComponent.hour = components.hour
        newComponent.minute = components.minute
        newComponent.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponent,repeats: false)
        
        let request = UNNotificationRequest(identifier: "TestNotification",content: content,trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error == nil {
                
                print("Notification Schduled",trigger.nextTriggerDate()?.formattedData ?? "Date nil")
                
            }
                
            else{
                
                print("Error schduling a notification",error?.localizedDescription ?? "")
                
            }
            
        }
        
        return trigger.nextTriggerDate()
    }
    
    
    func getAllPendingNotifications(completion:@escaping ([UNNotificationRequest]?)->Void){
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests:[UNNotificationRequest]) in
            return completion(requests)
        }
    }
    
    func cancelAllNotifcation(){
        
        
        getAllPendingNotifications { (requests:[UNNotificationRequest]?) in
            
            if let requestsIds = requests{
                
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestsIds.map{$0.identifier})
            }
            
        }
        
    }
    
}

extension NotificationManager:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Local Notification Received while app is open",notification.request.content)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Did tap on the notification",response.notification.request.content)
        
        
        completionHandler()
        
    }
    
    
}

extension Date{
    
    
    var formattedData:String{
        
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.timeStyle = .medium
        format.dateStyle = .medium
        
        return format.string(from: self)
        
    }
    
    
    
    
}
