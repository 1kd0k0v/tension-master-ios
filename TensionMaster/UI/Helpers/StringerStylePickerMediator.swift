//
//  StringerStylePickerMediator.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 4/21/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//

import UIKit

class StringerStylePickerMediator: PickerMediator, UIPickerViewDataSource {
    
    lazy var values = StringerStyle.allRepresentations
    
    override func value(row: Int, component: Int) -> String {
        return values[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
}
