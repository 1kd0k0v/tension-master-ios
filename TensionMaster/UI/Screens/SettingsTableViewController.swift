//
//  SettingsTableViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/28/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var modeLabel: UILabel!

    @IBOutlet var headSizeCell: UITableViewCell!
    @IBOutlet var headSizeValueLabel: UILabel!
    @IBOutlet var headSizePickerCell: UITableViewCell!
    @IBOutlet var headSizePicker: UIPickerView!
    @IBOutlet var headSizePickerMediator: HeadSizePickerMediator!
    
    @IBOutlet var stringDiameterCell: UITableViewCell!
    @IBOutlet var stringDiameterValueLabel: UILabel!
    @IBOutlet var stringDiameterPickerCell: UITableViewCell!
    @IBOutlet var stringDiameterPicker: UIPickerView!
    @IBOutlet var stringDiameterPickerMediator: StringDiameterPickerMediator!
    
    @IBOutlet var stringTypeCell: UITableViewCell!
    @IBOutlet var stringTypeValueLabel: UILabel!
    @IBOutlet var stringTypePickerCell: UITableViewCell!
    @IBOutlet var stringTypePicker: UIPickerView!
    @IBOutlet var stringTypePickerMediator: StringTypePickerMediator!
    
    @IBOutlet var tensionUnitsCell: UITableViewCell!
    @IBOutlet var tensionUnitsValueLabel: UILabel!
    @IBOutlet var tensionUnitsPickerCell: UITableViewCell!
    @IBOutlet var tensionUnitsPicker: UIPickerView!
    @IBOutlet var tensionUnitsPickerMediator: TensionUnitPickerMediator!
    
    var expandedPickerCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load settings data.
        reloadSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load only the selected mode since this is the only thing that can change outside this screen.
        modeLabel.text = "\(Settings.shared.measureMode.rawValue)"
    }
    
    // MARK: - Private Methods
    func reloadSettings() {
        let settings = Settings.shared
        // Selected mode.
        modeLabel.text = "\(settings.measureMode.rawValue)"
        // Head size.
        let headSizeUnit = settings.headSizeUnit.rawValue
        let headSize = settings.headSize
        if let index = headSizePickerMediator.headSizeUnits.firstIndex(of: headSizeUnit) {
            headSizePickerMediator.mode = (index == 0) ? .inches : .cm
            headSizePicker.selectRow(index, inComponent: 1, animated: false)
        }
        if let index = headSizePickerMediator.headSizes.firstIndex(of: headSize) {
            headSizePicker.selectRow(index, inComponent: 0, animated: false)
        }
        headSizeValueLabel.text = "\(headSize) \(headSizeUnit)"
        // String diameter
        let stringDiameter = settings.stringDiameter
        if let index = stringDiameterPickerMediator.stringDiameters.firstIndex(of: stringDiameter) {
            stringDiameterPicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringDiameterValueLabel.text = "\(String(format: "%0.2f", stringDiameter)) mm"
        // String type
        let stringType = settings.stringType.rawValue
        if let index = stringTypePickerMediator.stringTypes.firstIndex(of: stringType) {
            stringTypePicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringTypeValueLabel.text = stringType
        // Tension unit
        let tensionUnit = settings.tensionUnit.rawValue
        if let index = tensionUnitsPickerMediator.tensionUnits.firstIndex(of: tensionUnit) {
            tensionUnitsPicker.selectRow(index, inComponent: 0, animated: false)
        }
        tensionUnitsValueLabel.text = tensionUnit
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expandedHeight = CGFloat(160)
        let normalHeight = CGFloat(44)
        switch indexPath {
        case [1, 1]:
            return expandedPickerCell == headSizePickerCell ? expandedHeight : 0
        case [1, 3]:
            return expandedPickerCell == stringDiameterPickerCell ? expandedHeight : 0
        case [1, 5]:
            return expandedPickerCell == stringTypePickerCell ? expandedHeight : 0
        case [1, 7]:
            return expandedPickerCell == tensionUnitsPickerCell ? expandedHeight : 0
        default:
            return normalHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        // Racquet section.
        if indexPath.section == 1 {
            var correspondingPickerCell: UITableViewCell?
            switch selectedCell {
            case headSizeCell:
                correspondingPickerCell = headSizePickerCell
            case stringDiameterCell:
                correspondingPickerCell = stringDiameterPickerCell
            case stringTypeCell:
                correspondingPickerCell = stringTypePickerCell
            case tensionUnitsCell:
                correspondingPickerCell = tensionUnitsPickerCell
            default:
                break
            }
            
            // Collapse or open a picker.
            if expandedPickerCell == correspondingPickerCell {
                expandedPickerCell = nil
            } else {
                expandedPickerCell = correspondingPickerCell
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}

extension SettingsTableViewController: PickerMediatorDelegate {
    
    func pickerMediator(_ pickerMediator: PickerMediator,
                        forPicker picker: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
        let selectedValue = pickerMediator.selectedValue(component: 0)
        // Head size picker.
        if picker == headSizePicker {
            let selectedUnit = pickerMediator.selectedValue(component: 1)
            // Save it to settings.
            if let headSize = Double(selectedValue) {
                Settings.shared.headSize = headSize
            } else {
                assertionFailure("Cannot convert string to Double: \(selectedValue)")
            }
            if let headSizeUnit = SizeUnit(rawValue: selectedUnit) {
                Settings.shared.headSizeUnit = headSizeUnit
            } else {
                assertionFailure("Cannot convert string to SizeUnit: \(selectedUnit)")
            }
            // Display it.
            headSizeValueLabel.text = "\(selectedValue) \(selectedUnit)"
        } else if picker == stringDiameterPicker {
            // String diameter picker.
            if let stringDiameter = Double(selectedValue) {
                Settings.shared.stringDiameter = stringDiameter
            } else {
                assertionFailure("Cannot convert string to Double: \(selectedValue)")
            }
            // Display it.
            stringDiameterValueLabel.text = "\(selectedValue) mm"
        } else if picker == stringTypePicker {
            // String type picker.
            if let stringType = StringType(rawValue: selectedValue) {
                Settings.shared.stringType = stringType
            } else {
                assertionFailure("Cannot convert string to StringType: \(selectedValue)")
            }
            // Display it.
            stringTypeValueLabel.text = selectedValue
        } else if picker == tensionUnitsPicker {
            // Tension units picker.
            if let tensionUnit = TensionUnit(rawValue: selectedValue) {
                Settings.shared.tensionUnit = tensionUnit
            } else {
                assertionFailure("Cannot convert string to TensionUnit: \(selectedValue)")
            }
            // Display it.
            tensionUnitsValueLabel.text = selectedValue
        }
    }
    
}

