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
        // String diameter
        let stringDiameter = settings.stringDiameter
        if let index = stringDiameterPickerMediator.stringDiameters.firstIndex(of: stringDiameter) {
            stringDiameterPicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringDiameterValueLabel.text = "\(String(format: "%0.3f", stringDiameter)) mm"
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
        switch indexPath {
        case [2, 0]:    // Instructions.
            instructionsPressed()
        case [2, 1]:    // Video.
            videoPressed()
        case [3, 0]:    // Share.
            sharePressed()
        case [3, 1]:    // Feedback.
            feedbackPressed()
        case [3, 2]:    // Privacy Policy.
            privacyPolicyPressed()
        default:
            break
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
    
    func presentInformativeAlert(text: String) {
        let alert = UIAlertController(title: text, message: "Not implemented", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func instructionsPressed() {
        // Present alert with instructions.
        let message = """

                     ∙ If you use a Vibration Dampener take it off the string while measuring.

                     ∙ TensionMeter measures the average tension between main and cross strings of the racquet.

                     ∙ Enter the head size, the string diameter and the string type.

                     ∙ If you use main and cross strings with different diameter, enter the average diameter value.

                     ∙ You can use either Fabric or Personal mode(if Personal mode is activated make a Calibration of the mode).

                     ∙ Tap the racquet string with another racquet in front of the phone microphone to measure the average string tension

                     ∙ CAUTION ∙
                     ∙ The tension loss rate is very high immediately after the racquet is strung and during the first 30 minutes of play. The total tension loss after 1 hour of play could be up to 20% depending of the string model and the way of stringing.
                    """
        let alert = UIAlertController(title: "Instructions", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func videoPressed() {
        presentInformativeAlert(text: "Video")
    }
    
    func sharePressed() {
//        guard let url = URL(string: "https://play.google.com/store/apps/details?id=com.racquetbuddy") else {
//            return
//        }
        let text = "Hey check out my app at: https://play.google.com/store/apps/details?id=com.racquetbuddy"
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
        guard let url = URL(string: "https://robustasoft.com/tensionmaster-privacypolicy/") else { return }
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

