//
//  HeadSizePickerMediator.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/28/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

enum HeadSizePickerMediatorMode {
    case inches
    case cm
}

class HeadSizePickerMediator: PickerMediator, UIPickerViewDataSource {

    lazy var headSizesInches = Array(Settings.shared.headSizeInchRange).map(Double.init)
    lazy var headSizesCm = Array(Settings.shared.headSizeCmRange).map(Double.init)
    var headSizes: [Double] {
        switch mode {
        case .inches: return headSizesInches
        case .cm: return headSizesCm
        }
    }
    lazy var headSizeUnits = SizeUnit.allRepresentations
    var mode = HeadSizePickerMediatorMode.inches
    // Applying a new mode animated.
    func applyMode(_ mode: HeadSizePickerMediatorMode) {
        if self.mode != mode {
            self.mode = mode
            pickerView.reloadComponent(0)
            pickerView.selectRow(headSizes.count / 2, inComponent: 0, animated: true)
        }
    }
    
    override func value(row: Int, component: Int) -> String {
        if component == 0 {
            return "\(headSizes[row])"
        } else {
            return headSizeUnits[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? headSizes.count : headSizeUnits.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            if row == 0 {
                applyMode(.inches)
            } else {
                applyMode(.cm)
            }
        }
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
    }
    
}
