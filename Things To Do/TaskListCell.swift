//
//  TaskListCell.swift
//  Things To Do
//
//  Created by Kewal Kanojia on 29/07/17.
//  Copyright © 2017 Kewal Kanojia. All rights reserved.
//

import UIKit

class TaskListCell: UITableViewCell {

    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
