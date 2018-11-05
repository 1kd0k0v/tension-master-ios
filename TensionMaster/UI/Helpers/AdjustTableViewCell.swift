//
//  AdjustTableViewCell.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 11/5/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

protocol AdjustTableViewCellDelegate: class {
    func adjustCellSelectAdjust(_ cell: AdjustTableViewCell)
}

class AdjustTableViewCell: UITableViewCell {
    
    @IBOutlet private var fabricModeCurcle: UIView!
    @IBOutlet private var fabricValueLabel: UILabel!
    @IBOutlet private var fabricUnitLabel: UILabel!
    
    @IBOutlet private var personalModeCurcle: UIView!
    @IBOutlet private var personalValueLabel: UILabel!
    @IBOutlet private var personalUnitLabel: UILabel!
    
    @IBOutlet private var adjustmentLabel: UILabel!
    
    weak var delegate: AdjustTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fabricModeCurcle.layer.cornerRadius = fabricModeCurcle.bounds.width / 2
        personalModeCurcle.layer.cornerRadius = personalModeCurcle.bounds.width / 2
        let tensionUnit = Settings.shared.tensionUnit
        fabricUnitLabel.text = tensionUnit.rawValue
        personalUnitLabel.text = tensionUnit.rawValue
    }
    
    func update(adjustment: Double) {
        if adjustment >= 0.0 {
            adjustmentLabel.text = "(+\(String(format: "%0.2f", adjustment)) \(Settings.shared.tensionUnit.rawValue))"
        } else {
            adjustmentLabel.text = "(\(String(format: "%0.2f", adjustment)) \(Settings.shared.tensionUnit.rawValue))"
        }
    }
    
    @IBAction func adjustPressed(button: UIButton) {
        delegate?.adjustCellSelectAdjust(self)
    }

}
