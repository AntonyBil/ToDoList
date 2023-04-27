//
//  ListTableViewCell.swift
//  ToDoList
//
//  Created by apple on 13.03.2023.
//

import UIKit

protocol ListTableViewCellDelegate: AnyObject {
    func checkBoxTpggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ListTableViewCellDelegate?
    
    var toDoItem: ToDoItem! {
        didSet {
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.complited
        }
    }
    
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxTpggle(sender: self)
    }
    
    
}
