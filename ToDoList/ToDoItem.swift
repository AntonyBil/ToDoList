//
//  ToDoItem.swift
//  ToDoList
//
//  Created by apple on 06.03.2023.
//

import Foundation

struct ToDoItem: Codable {
    var name: String
    var date: Date
    var notes: String
    var reminderSet: Bool
    var notificationID: String?
    var complited: Bool
}
