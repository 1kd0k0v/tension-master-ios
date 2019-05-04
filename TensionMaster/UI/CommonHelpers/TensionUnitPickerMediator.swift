//
//  TensionUnitPickerMediator.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 11/1/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class TensionUnitPickerMediator: PickerMediator, UIPickerViewDataSource {
    
    lazy var tensionUnits = TensionUnit.allRepresentations
    
    override func value(row: Int, component: Int) -> String {
        return tensionUnits[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tensionUnits.count
    }
    
}
