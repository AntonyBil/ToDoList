//
//  UIViewController + alert.swift
//  ToDoList
//
//  Created by apple on 30.03.2023.
//

import UIKit

extension UIViewController {
    func oneButtonAlert(title: String, massage: String) {
        let alertController = UIAlertController(title: title, message: massage , preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default)
        present(alertController, animated: true)
    }
}


