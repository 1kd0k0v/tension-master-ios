//
//  SettingsTableViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/28/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet var headSizeCell: UITableViewCell!
    @IBOutlet var headSizeValueLabel: UILabel!
    @IBOutlet var headSizePickerCell: UITableViewCell!
    @IBOutlet var headSizePicker: UIPickerView!
    @IBOutlet var headSizePickerMediator: HeadSizePickerMediator!
    
    @IBOutlet var stringDiameterCell: UITableViewCell!
    @IBOutlet var stringDiameterPickerCell: UITableViewCell!
    @IBOutlet var stringDiameterPicker: UIPickerView!
    
    @IBOutlet var stringTypeCell: UITableViewCell!
    @IBOutlet var stringTypePickerCell: UITableViewCell!
    @IBOutlet var stringTypePicker: UIPickerView!
    
    @IBOutlet var tensionUnitsCell: UITableViewCell!
    @IBOutlet var tensionUnitsPickerCell: UITableViewCell!
    @IBOutlet var tensionUnitsPicker: UIPickerView!
    
    var expandedPickerCell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headSizePicker.selectRow(headSizePickerMediator.headSizes.count / 2, inComponent: 0, animated: true)
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

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsTableViewController: PickerMediatorDelegate {
    
    func pickerMediator(_ pickerMediator: PickerMediator,
                        forPicker picker: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
        if picker == headSizePicker {
            let firstPart = pickerMediator.selectedValue(component: 0)
            let secondPart = pickerMediator.selectedValue(component: 1)
            headSizeValueLabel.text = "\(firstPart)\(secondPart)"
            if component == 1 {
                if row == 0 {
                    // in² picked.
                } else {
                    // cm² picked.
                    
                }
            }
        }
    }
    
}

extension SettingsTableViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 20
        default:
            return 2
        }
    }
    
}

extension SettingsTableViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "cmp:\(component)|row:\(row)"
    }
    
}
