//
//  SettingsTableViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/28/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var modeLabel: UILabel!

    // Racquet section.
    @IBOutlet var headSizeCell: UITableViewCell!
    @IBOutlet var headSizeValueLabel: UILabel!
    @IBOutlet var headSizePickerCell: UITableViewCell!
    @IBOutlet var headSizePicker: UIPickerView!
    @IBOutlet var headSizePickerMediator: HeadSizePickerMediator!
    
    @IBOutlet var tensionUnitsCell: UITableViewCell!
    @IBOutlet var tensionUnitsValueLabel: UILabel!
    @IBOutlet var tensionUnitsPickerCell: UITableViewCell!
    @IBOutlet var tensionUnitsPicker: UIPickerView!
    @IBOutlet var tensionUnitsPickerMediator: TensionUnitPickerMediator!
    
    // String section.
    @IBOutlet var hybridStringingCell: UITableViewCell!
    @IBOutlet var hybridStringingSwitch: UISwitch!
    
    @IBOutlet var stringModelCell: UITableViewCell!
    @IBOutlet var crossStringModelCell: UITableViewCell!
    
    // About section.
    @IBOutlet var versionLabel: UILabel!
    
    var expandedPickerCell: UITableViewCell?
    
    lazy var versionString: String = {
        var fullVersion = ""
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            fullVersion = "\(version)"
        }
        if let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            fullVersion += "(\(build))"
        }
        return fullVersion
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLabel.text = versionString
        // Load settings data.
        reloadSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load only the selected mode since this is the only thing that can change outside this screen.
        modeLabel.text = "\(Settings.shared.measureMode.rawValue)"
    }
    
    // MARK: - Private Methods
    private func reloadSettings() {
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
        headSizeValueLabel.text = "\(Int(headSize)) \(headSizeUnit)"
        // Hybrid stringng.
        hybridStringingSwitch.isOn = settings.hybridStringing
        if settings.hybridStringing {
            stringModelCell.textLabel?.text = "Main Model"
        } else {
            stringModelCell.textLabel?.text = "Model"
        }
        // String model - type + diameter.
        stringModelCell.detailTextLabel?.text = "\(settings.stringType.rawValue) - \(settings.formattedStringDiameter) mm"
        // Cross model - type + diameter.
        crossStringModelCell.detailTextLabel?.text = "\(settings.crossStringType.rawValue) - \(settings.formattedCrossStringDiameter) mm"
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
        let stringModelHeight = CGFloat(64)
        switch indexPath {
        case [1, 1]:
            return expandedPickerCell == headSizePickerCell ? expandedHeight : 0
        case [1, 3]:
            return expandedPickerCell == tensionUnitsPickerCell ? expandedHeight : 0
        case [2, 1]:
            return stringModelHeight
        case [2, 2]:
            return Settings.shared.hybridStringing ? stringModelHeight : 0
        default:
            return normalHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        // Racquet or String section.
        if indexPath.section == 1 || indexPath.section == 2 {
            var correspondingPickerCell: UITableViewCell?
            switch selectedCell {
            case headSizeCell:
                correspondingPickerCell = headSizePickerCell
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
        } else {
            // The rest of the cells.
            switch indexPath {
            case [3, 0]:    // Instructions.
                instructionsPressed()
            case [3, 1]:    // Video.
                videoPressed()
            case [4, 0]:    // Share.
                sharePressed()
            case [4, 1]:    // Feedback.
                feedbackPressed()
            case [4, 2]:    // Privacy Policy.
                privacyPolicyPressed()
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.accent
        }
    }

}

// MARK: - Handle Actions - Private
private extension SettingsTableViewController {
    
    @IBAction func hybridStringingValueChanged(control: UISwitch) {
        Settings.shared.hybridStringing = control.isOn
        if control.isOn {
            stringModelCell.textLabel?.text = "Main Model"
        } else {
            stringModelCell.textLabel?.text = "Model"
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func instructionsPressed() {
        // Present alert with instructions.
        let message = """

                     ∙ TennisTension measures the average tension between main and cross strings by analyzing the sound heard from the string.

                     ∙ Take off the Dampener.

                     ∙ Put the head size, the string diameter and it's type (if main and cross strings are with different diameter put the average value).

                     ∙ Use Fabric or Personal mode.

                     ∙ By Calibration of the Personal mode you can cope with all particularities of the racquets, strings, stringers and stringing machines.

                     ∙ Tap the racquet string anywhere with anything close to the phone microphone.

                     ∙ Consider the tension loss receiving the outcome of the measurement.
                    """
        let alert = UIAlertController(title: "Instructions", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func videoPressed() {
        guard let url = URL(string: "https://www.youtube.com/watch?v=QZGqs-9C-6I&feature=youtu.be&fbclid=IwAR1OjmFa7cPIOLepVzMz2R_MDQQTC9oYoFHqizzC20SR_lZlBbem_BzrhUc") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func sharePressed() {
//        guard let url = URL(string: "https://play.google.com/store/apps/details?id=com.racquetbuddy") else {
//            return
//        }
        let text = "Hey check out my app at: http://itunes.apple.com/app/id1441997912"
        let shareVC = UIActivityViewController(activityItems: [text/*, url*/], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func feedbackPressed() {
        guard MFMailComposeViewController.canSendMail() else {
            let alert = UIAlertController(title: "Cannot send mail",
                                          message: "You are currently unable to send mails. Please check if your mail client is properly configured and try again.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["ikdokov@gmail.com"])
        composeVC.setSubject("Tension Master")
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func privacyPolicyPressed() {
        guard let url = URL(string: "https://craftsoftlabs.com/tensionmaster-privacypolicy/") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate
extension SettingsTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - PickerMediatorDelegate
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

