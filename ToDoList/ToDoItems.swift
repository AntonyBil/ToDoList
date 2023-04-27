//
//  ToDoItems.swift
//  ToDoList
//
//  Created by apple on 29.03.2023.
//

import Foundation
import UserNotifications


class ToDoItems {
    var itemsArray: [ToDoItem] = []
    
    func saveData() {
        //дерикторія
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        //документ
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(itemsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("😡 ERROR: Could not save data \(error.localizedDescription)")
        }
        // Notif 6
        setNotifications()
    }
    
    //MARK: - Load Data
    //замикання
    func loadData(completed: @escaping()->()) {
            //дерикторія
            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            //документ
            let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
            
            guard let data = try? Data(contentsOf: documentURL) else {return}
            let jsonDecoder = JSONDecoder()
            do {
                itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            } catch {
                print("😡 ERROR: Could not save data \(error.localizedDescription)")
            }
            completed()
        }
    
    //Notif 5
    func setNotifications() {
        guard itemsArray.count > 0 else {
            return
        }
        // remove all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        //and let's re-create them with the updated data that we just saved
        for index in 0..<itemsArray.count {
            if itemsArray[index].reminderSet {
                let toDoItem = itemsArray[index]
                itemsArray[index].notificationID = LocalNotificationManager.setCalendarNotifications(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
}
