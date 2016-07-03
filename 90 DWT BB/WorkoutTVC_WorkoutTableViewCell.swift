//
//  WorkoutTVC_WorkoutTableViewCell.swift
//  90 DWT BB
//
//  Created by Jared Grant on 7/2/16.
//  Copyright © 2016 Grant, Jared. All rights reserved.
//

import UIKit

class WorkoutTVC_WorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var repNumberLabel1: UILabel!
    @IBOutlet weak var repNumberLabel2: UILabel!
    @IBOutlet weak var repNumberLabel3: UILabel!
    @IBOutlet weak var repNumberLabel4: UILabel!
    @IBOutlet weak var repNumberLabel5: UILabel!
    @IBOutlet weak var repNumberLabel6: UILabel!
    
    @IBOutlet weak var repTitleLabel1: UILabel!
    @IBOutlet weak var repTitleLabel2: UILabel!
    @IBOutlet weak var repTitleLabel3: UILabel!
    @IBOutlet weak var repTitleLabel4: UILabel!
    @IBOutlet weak var repTitleLabel5: UILabel!
    @IBOutlet weak var repTitleLabel6: UILabel!
    
    @IBOutlet weak var previousWeight1: UITextField!
    @IBOutlet weak var previousWeight2: UITextField!
    @IBOutlet weak var previousWeight3: UITextField!
    @IBOutlet weak var previousWeight4: UITextField!
    @IBOutlet weak var previousWeight5: UITextField!
    @IBOutlet weak var previousWeight6: UITextField!
    
    @IBOutlet weak var currentWeight1: UITextField!
    @IBOutlet weak var currentWeight2: UITextField!
    @IBOutlet weak var currentWeight3: UITextField!
    @IBOutlet weak var currentWeight4: UITextField!
    @IBOutlet weak var currentWeight5: UITextField!
    @IBOutlet weak var currentWeight6: UITextField!
    
    @IBOutlet weak var previousNotes: UITextField!
    @IBOutlet weak var currentNotes: UITextField!
    
    @IBOutlet weak var graphButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
