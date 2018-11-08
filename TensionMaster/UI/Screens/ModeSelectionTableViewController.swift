//
//  ModeSelectionTableViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 11/5/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class ModeSelectionTableViewController: UITableViewController {
    
    lazy var settings = Settings.shared
    
    var fabricModeCell: UITableViewCell?
    var personalModeCell: UITableViewCell?
    var adjustCell: AdjustTableViewCell?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if settings.measureMode == .fabric {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else {
            return "How does it work? \n 1. String your racquet by trusted stringer. \n 2. Measure the tension. \n 3. Adjust if needed."
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return 220
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        switch indexPath {
        case [0, 0]:    // Fabric mode.
            cell = tableView.dequeueReusableCell(withIdentifier: "ModeCell", for: indexPath)
            fabricModeCell = cell
        case [0, 1]:    // Personal mode.
            cell = tableView.dequeueReusableCell(withIdentifier: "ModeCell", for: indexPath)
            personalModeCell = cell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "AdjustCell", for: indexPath)
            adjustCell = cell as? AdjustTableViewCell
            adjustCell?.delegate = self
        }
        update(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    func update(cell: UITableViewCell?, forIndexPath indexPath: IndexPath) {
        
        switch indexPath {
        case [0, 0]:    // Fabric mode.
            cell?.textLabel?.text = "Fabric"
            cell?.accessoryType = settings.measureMode == .fabric ? .checkmark : .none
        case [0, 1]:    // Personal mode.
            cell?.textLabel?.text = "Personal"
            cell?.accessoryType = settings.measureMode == .personal ? .checkmark : .none
        default:
            if let adjustCell = cell as? AdjustTableViewCell {
                adjustCell.update(adjustment: settings.tensionAdjustment)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.beginUpdates()
            if indexPath.row == 0, settings.measureMode == .personal {
                settings.measureMode = .fabric
                update(cell: fabricModeCell, forIndexPath: [0, 0])
                update(cell: personalModeCell, forIndexPath: [0, 1])
                tableView.deleteSections(IndexSet(integer: 1), with: .fade)
            } else if indexPath.row == 1, settings.measureMode == .fabric {
                settings.measureMode = .personal
                update(cell: fabricModeCell, forIndexPath: [0, 0])
                update(cell: personalModeCell, forIndexPath: [0, 1])
                tableView.insertSections(IndexSet(integer: 1), with: .fade)
            }
            tableView.endUpdates()
        }
    }

}

extension ModeSelectionTableViewController: AdjustTableViewCellDelegate {
    
    func adjustCellSelectAdjust(_ cell: AdjustTableViewCell) {
        let alert = UIAlertController(title: "Enter tension", message: "Please enter your just stringed racquet tension.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "String tension"
            textField.keyboardType = .decimalPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let text = alert.textFields?.first?.text, let adjustment = Double(text) {
                self.settings.tensionAdjustment = adjustment
                self.tableView.reloadData()
            }
        }))
        present(alert, animated: true)
    }
    
}
