//
//  StringDiameterPickerMediator.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/31/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class StringDiameterPickerMediator: PickerMediator, UIPickerViewDataSource {
    
    lazy var stringDiameters = Array(Settings.shared.stringDiameterStride)
    
    override func value(row: Int, component: Int) -> String {
        return String(format: "%0.3f", stringDiameters[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stringDiameters.count
    }
    
}
