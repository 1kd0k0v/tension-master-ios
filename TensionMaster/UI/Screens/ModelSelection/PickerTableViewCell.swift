//
//  PickerTableViewCell.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 3/31/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//

import UIKit

class PickerTableViewCell: DarkTableViewCell {
    
    @IBOutlet var picker: UIPickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMediator(_ mediator: (PickerMediator & UIPickerViewDataSource)?) {
        // Just link them together.
        mediator?.pickerView = picker
        picker.delegate = mediator
        picker.dataSource = mediator
    }

}
