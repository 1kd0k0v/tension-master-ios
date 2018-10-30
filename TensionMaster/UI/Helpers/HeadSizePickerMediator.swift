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

    lazy var headSizesInches = Array(50...100)
    lazy var headSizesCm = Array(200...400)
    var headSizes: [Int] {
        switch mode {
        case .inches: return headSizesInches
        case .cm: return headSizesCm
        }
    }
    lazy var headSizeMeasures = ["in²", "cm²"]
    var mode = HeadSizePickerMediatorMode.inches {
        didSet {
            if oldValue != mode {
                pickerView.reloadComponent(0)
                pickerView.selectRow(headSizes.count / 2, inComponent: 0, animated: true)
            }
        }
    }
    
    override func value(row: Int, component: Int) -> String {
        if component == 0 {
            return "\(headSizes[row])"
        } else {
            return headSizeMeasures[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? headSizes.count : headSizeMeasures.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            if row == 0 {
                mode = .inches
            } else {
                mode = .cm
            }
        }
        super.pickerView(pickerView, didSelectRow: row, inComponent: component)
    }
    
}
