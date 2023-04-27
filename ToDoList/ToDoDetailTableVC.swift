//
//  ToDoDetailTableVC.swift
//  ToDoList
//
//  Created by apple on 05.03.2023.
//

import UIKit
import UserNotifications

// DateFormatter()
private let dateFormatter: DateFormatter = {
    print("📅 I just create a date formatter")
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
}()

class ToDoDetailTableVC: UITableViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var noteView: UITextView!
    
    @IBOutlet weak var reminderSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!

    
    //1_змінна яка приямає шнформацію
    //2
    var toDoItem: ToDoItem!
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let notesRowHight: CGFloat = 200
    let defaultRowHight: CGFloat = 44
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup foreground notifications
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appActiveNotifications), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //клавиатура пропадат когда мы тапаем на другой обект
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        nameField.delegate = self
        
        //7_
        if toDoItem == nil {
            toDoItem = ToDoItem(name: "", date: Date().addingTimeInterval(24*60*60), notes: "", reminderSet: false, complited: false)
            
            nameField.becomeFirstResponder()
        }
        
        updateUserInterface()
        
    }
    
    @objc func appActiveNotifications() {
        print("The app just came to the foreground - cool!")
        updateReminderSwitch()
    }
    
    func updateUserInterface() {
        // 2_виводимо iнформацію
        nameField.text = toDoItem.name
        datePicker.date = toDoItem.date
        noteView.text = toDoItem.notes
        reminderSwitch.isOn = toDoItem.reminderSet
        dateLabel.textColor = (reminderSwitch.isOn ? .black : .gray)
        dateLabel.text = dateFormatter.string(from: toDoItem.date)
        enableDisebleSaveButton(text: nameField.text ?? "")
        updateReminderSwitch()
    }
    
    func updateReminderSwitch() {
        LocalNotificationManager.isAutherized { authorized in
            DispatchQueue.main.async {
                // authorized == false
                if !authorized && self.reminderSwitch.isOn {
                    self.oneButtonAlert(title: "User Has Not Allowed Notifications", massage: "To receive alert for reminders, open the Settings app, select To Do List > Notifications > Allow Notifications.")
                }
                self.view.endEditing(true)
                self.dateLabel.textColor = (self.reminderSwitch.isOn ? .black : .gray)
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
    }
    
    func enableDisebleSaveButton(text: String) {
        if text.count > 0 {
            saveBarButton.isEnabled = true
        } else {
            saveBarButton.isEnabled = false
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        enableDisebleSaveButton(text: sender.text!)
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        dateLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIBarButtonItem) {
        //перемикач між dismis and pop
        let isPresentingInAddMode = presentingViewController is UINavigationController
            if isPresentingInAddMode {
                dismiss(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    
  //MARK: -  Switch
    @IBAction func reminderSwitchChanged(_ sender: UISwitch) {
       updateReminderSwitch()
    }
    
    //MARK: - Segue
    // 4_ відправляємо назад
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        toDoItem = ToDoItem(name: nameField.text!, date: datePicker.date, notes: noteView.text, reminderSet: reminderSwitch.isOn, complited: toDoItem.complited)
    }
}

//програмуємо висоту ячійок
extension ToDoDetailTableVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return reminderSwitch.isOn ? datePicker.frame.height : 0
        case notesTextViewIndexPath:
            return notesRowHight
        default:
            return defaultRowHight
        }
    }
    
    
}

extension ToDoDetailTableVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //автоматично перекидаэ курсор
        noteView.becomeFirstResponder()
        return true
    }
}
