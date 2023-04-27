//
//  LocalNotificationsManager.swift
//  ToDoList
//
//  Created by apple on 29.03.2023.
//

import Foundation
import UserNotifications
import UIKit

//helper
struct LocalNotificationManager {
    
    //MARK: - Notifications 3
    static func autherizeLocalNotifications(viewController: UIViewController) {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
               guard error == nil else {
                   print("😡 ERROR: \(error!.localizedDescription)")
                   return
               }
               if granted {
                   print("✅ Notifications Autorization Granted!")
               } else {
                   print("🚫 The user has denied notifications!")
                   //використовуємо DIspatchQueue для переходу в main
                   DispatchQueue.main.async {
                       //TODO: Put an alert in here teling the user what to do
                       viewController.oneButtonAlert(title: "User Has Not Allowed Notifications", massage: "To receive alert for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                   }
               }
           }
       }
    
    static func isAutherized(completed: @escaping (Bool)->() ) {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
               guard error == nil else {
                   print("😡 ERROR: \(error!.localizedDescription)")
                   completed(false)
                   return
               }
               if granted {
                   print("✅ Notifications Autorization Granted!")
                   completed(true)
               } else {
                   print("🚫 The user has denied notifications!")
                   completed(false)
                   }
               }
           }
       
    
    //Notif 4
 static func setCalendarNotifications(title: String, subtitle: String, body: String, badgeNumber: NSNumber?, sound: UNNotificationSound?, date: Date) -> String {
        //create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        
        //create trigger
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register request with the notifications center
        UNUserNotificationCenter.current().add(request){(error) in
            if let error = error {
                print("😡 Error: \(error.localizedDescription) Yikes, adding notification request went wrong!")
            } else {
                print("Notification scheduled \(notificationID), title: \(content.title)")
            }
        }
        return notificationID
    }
}

