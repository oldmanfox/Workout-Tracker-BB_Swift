//
//  WorkoutTVC_CompletionTableViewCell.swift
//  90 DWT BB
//
//  Created by Jared Grant on 7/2/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WorkoutTVC_CompletionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var deleteDateButton: UIButton!
    @IBOutlet weak var todayDateButton: UIButton!
    @IBOutlet weak var previousDateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
