//
//  RoomCell.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit

class RoomCell: UITableViewCell {

    var room: Room? {
        didSet {
            roomLabel.text = room?.name
            levelLabel.text = room?.officeLevel?.value
            departmentLabel.text = room?.department
            typeLabel.text = room?.type ?? room?.typ
            roomNumber.text = room?.roomNumber?.value
        }
    }
    
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var roomNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
