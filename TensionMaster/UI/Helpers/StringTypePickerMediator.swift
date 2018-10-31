//
//  StringTypePickerMediator.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/31/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class StringTypePickerMediator: PickerMediator, UIPickerViewDataSource {
    
    lazy var stringTypes = StringType.allRepresentations
    
    override func value(row: Int, component: Int) -> String {
        return stringTypes[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stringTypes.count
    }
    
}
