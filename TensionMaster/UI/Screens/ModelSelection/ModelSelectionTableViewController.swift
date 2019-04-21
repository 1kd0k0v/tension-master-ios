//
//  ModelSelectionTableViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 3/31/19.
//  Copyright © 2019 Nikolay Markov. All rights reserved.
//

import UIKit

class ModelSelectionTableViewController: UITableViewController {
    
    lazy var settings = Settings.shared
    
    // Thickness.
    var thicknessCell: UITableViewCell?
    var thicknessPickerCell: PickerTableViewCell?
    var thicknessPickerMediator: StringDiameterPickerMediator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case [0, 0]:
            return 44
        default:
            return 160
        }
//        if indexPath.section == 0 {
//            return 44
//        } else {
//            return 320
//        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath {
        case [0, 0]:    // Thickness cell.
            cell = tableView.dequeueReusableCell(withIdentifier: "ThicknessCell", for: indexPath)
            cell.textLabel?.text = "Thickness"
            cell.detailTextLabel?.text = "\(settings.formattedStringDiameter) mm"
            thicknessCell = cell
        case [0, 1]:    // Thickness picker cell.
            cell = tableView.dequeueReusableCell(withIdentifier: "ThicknessPickerCell", for: indexPath)
            if thicknessPickerCell == nil {
                thicknessPickerCell = cell as? PickerTableViewCell
                thicknessPickerMediator = StringDiameterPickerMediator()
                thicknessPickerMediator?.delegate = self
                thicknessPickerCell?.setMediator(thicknessPickerMediator)
            }
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "ThicknessCell", for: indexPath)
        }
        update(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    func update(cell: UITableViewCell?, forIndexPath indexPath: IndexPath) {
        
//        switch indexPath {
//        case [0, 0]:    // Factory mode.
//            cell?.textLabel?.text = "Factory"
//            cell?.accessoryType = settings.measureMode == .fabric ? .checkmark : .none
//        case [0, 1]:    // Personal mode.
//            cell?.textLabel?.text = "Personal"
//            cell?.accessoryType = settings.measureMode == .personal ? .checkmark : .none
//        default:
//            if let adjustCell = cell as? AdjustTableViewCell {
//                adjustCell.update(adjustment: settings.tensionAdjustment)
//            }
//        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

// MARK: - PickerMediatorDelegate
extension ModelSelectionTableViewController: PickerMediatorDelegate {
    
    func pickerMediator(_ pickerMediator: PickerMediator,
                        forPicker picker: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
        let selectedValue = pickerMediator.selectedValue(component: 0)
        if let stringDiameter = Double(selectedValue) {
            settings.stringDiameter = stringDiameter
        } else {
            assertionFailure("Cannot convert string to Double: \(selectedValue)")
        }
        // Refresh the cell to display the change.
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
    }
    
}
