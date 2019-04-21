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
    
    @IBOutlet var frameAndGrommetsCell: UITableViewCell!
    @IBOutlet var frameAndGrommetsValueLabel: UILabel!
    @IBOutlet var frameAndGrommetsPickerCell: UITableViewCell!
    @IBOutlet var frameAndGrommetsPicker: UIPickerView!
    @IBOutlet var frameAndGrommetsPickerMediator: FrameAndGrommetsPickerMediator!
    
    @IBOutlet var stringPatternCell: UITableViewCell!
    @IBOutlet var stringPatternValueLabel: UILabel!
    @IBOutlet var stringPatternPickerCell: UITableViewCell!
    @IBOutlet var stringPatternPicker: UIPickerView!
    @IBOutlet var stringPatternPickerMediator: StringPatternPickerMediator!
    
    // String section.
    @IBOutlet var stringerStyleCell: UITableViewCell!
    @IBOutlet var stringerStyleValueLabel: UILabel!
    @IBOutlet var stringerStylePickerCell: UITableViewCell!
    @IBOutlet var stringerStylePicker: UIPickerView!
    @IBOutlet var stringerStylePickerMediator: StringerStylePickerMediator!
    
    @IBOutlet var hybridStringingCell: UITableViewCell!
    @IBOutlet var hybridStringingSwitch: UISwitch!
    
    @IBOutlet var stringDiameterCell: UITableViewCell!
    @IBOutlet var stringDiameterLabel: UILabel!
    @IBOutlet var stringDiameterValueLabel: UILabel!
    @IBOutlet var stringDiameterPickerCell: UITableViewCell!
    @IBOutlet var stringDiameterPicker: UIPickerView!
    @IBOutlet var stringDiameterPickerMediator: StringDiameterPickerMediator!
    
    @IBOutlet var stringTypeCell: UITableViewCell!
    @IBOutlet var stringTypeLabel: UILabel!
    @IBOutlet var stringTypeValueLabel: UILabel!
    @IBOutlet var stringTypePickerCell: UITableViewCell!
    @IBOutlet var stringTypePicker: UIPickerView!
    @IBOutlet var stringTypePickerMediator: StringTypePickerMediator!
    
    @IBOutlet var crossStringDiameterCell: UITableViewCell!
    @IBOutlet var crossStringDiameterValueLabel: UILabel!
    @IBOutlet var crossStringDiameterPickerCell: UITableViewCell!
    @IBOutlet var crossStringDiameterPicker: UIPickerView!
    @IBOutlet var crossStringDiameterPickerMediator: StringDiameterPickerMediator!
    
    @IBOutlet var crossStringTypeCell: UITableViewCell!
    @IBOutlet var crossStringTypeValueLabel: UILabel!
    @IBOutlet var crossStringTypePickerCell: UITableViewCell!
    @IBOutlet var crossStringTypePicker: UIPickerView!
    @IBOutlet var crossStringTypePickerMediator: StringTypePickerMediator!
    
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
        // Frame and Grommets.
        let frameAndGrommets = settings.frameAndGrommets.rawValue
        if let index = frameAndGrommetsPickerMediator.values.firstIndex(of: frameAndGrommets) {
            frameAndGrommetsPicker.selectRow(index, inComponent: 0, animated: false)
        }
        frameAndGrommetsValueLabel.text = frameAndGrommets
        // String pattern.
        let stringPattern = settings.stringPattern.rawValue
        if let index = stringPatternPickerMediator.values.firstIndex(of: stringPattern) {
            stringPatternPicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringPatternValueLabel.text = stringPattern
        // Stringer's style.
        let stringerStyle = settings.stringerStyle.rawValue
        if let index = stringerStylePickerMediator.values.firstIndex(of: stringerStyle) {
            stringerStylePicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringerStyleValueLabel.text = stringerStyle
        // Hybrid stringng.
        hybridStringingSwitch.isOn = settings.hybridStringing
        if settings.hybridStringing {
            stringDiameterLabel.text = "Main Thickness"
            stringTypeLabel.text = "Main Type"
        } else {
            stringDiameterLabel.text = "Thickness"
            stringTypeLabel.text = "Type"
        }
        // String diameter
        let stringDiameter = settings.stringDiameter
        if let index = stringDiameterPickerMediator.stringDiameters.firstIndex(of: stringDiameter) {
            stringDiameterPicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringDiameterValueLabel.text = "\(settings.formattedStringDiameter) mm"
        // String type
        let stringType = settings.stringType.rawValue
        if let index = stringTypePickerMediator.stringTypes.firstIndex(of: stringType) {
            stringTypePicker.selectRow(index, inComponent: 0, animated: false)
        }
        stringTypeValueLabel.text = stringType
        // Cross string diameter
        let crossStringDiameter = settings.crossStringDiameter
        if let index = crossStringDiameterPickerMediator.stringDiameters.firstIndex(of: crossStringDiameter) {
            crossStringDiameterPicker.selectRow(index, inComponent: 0, animated: false)
        }
        crossStringDiameterValueLabel.text = "\(settings.formattedCrossStringDiameter) mm"
        // Cross string type
        let crossStringType = settings.crossStringType.rawValue
        if let index = crossStringTypePickerMediator.stringTypes.firstIndex(of: crossStringType) {
            crossStringTypePicker.selectRow(index, inComponent: 0, animated: false)
        }
        crossStringTypeValueLabel.text = crossStringType
        // Tension unit
        let tensionUnit = settings.tensionUnit.rawValue
        if let index = tensionUnitsPickerMediator.tensionUnits.firstIndex(of: tensionUnit) {
            tensionUnitsPicker.selectRow(index, inComponent: 0, animated: false)
        }
        tensionUnitsValueLabel.text = tensionUnit
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if Settings.shared.hybridStringing == false {
            switch indexPath {
            case [1, 7], [1, 8], [1, 9], [1, 10]:
                return 0
            default:
                break
            }
        }
        let expandedHeight = CGFloat(160)
        let normalHeight = CGFloat(44)
        switch indexPath {
        case [0, 1]:
            return expandedPickerCell == headSizePickerCell ? expandedHeight : 0
        case [0, 3]:
            return expandedPickerCell == tensionUnitsPickerCell ? expandedHeight : 0
        case [0, 5]:
            return expandedPickerCell == frameAndGrommetsPickerCell ? expandedHeight : 0
        case [0, 7]:
            return expandedPickerCell == stringPatternPickerCell ? expandedHeight : 0
        case [1, 1]:
            return expandedPickerCell == stringerStylePickerCell ? expandedHeight : 0
        case [1, 4]:
            return expandedPickerCell == stringDiameterPickerCell ? expandedHeight : 0
        case [1, 6]:
            return expandedPickerCell == stringTypePickerCell ? expandedHeight : 0
        case [1, 8]:
            return expandedPickerCell == crossStringDiameterPickerCell ? expandedHeight : 0
        case [1, 10]:
            return expandedPickerCell == crossStringTypePickerCell ? expandedHeight : 0
        default:
            return normalHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        // Racquet or String section.
        if indexPath.section == 0 || indexPath.section == 1 {
            var correspondingPickerCell: UITableViewCell?
            switch selectedCell {
            case headSizeCell:
                correspondingPickerCell = headSizePickerCell
            case stringDiameterCell:
                correspondingPickerCell = stringDiameterPickerCell
            case stringTypeCell:
                correspondingPickerCell = stringTypePickerCell
            case crossStringDiameterCell:
                correspondingPickerCell = crossStringDiameterPickerCell
            case crossStringTypeCell:
                correspondingPickerCell = crossStringTypePickerCell
            case tensionUnitsCell:
                correspondingPickerCell = tensionUnitsPickerCell
            case frameAndGrommetsCell:
                correspondingPickerCell = frameAndGrommetsPickerCell
            case stringPatternCell:
                correspondingPickerCell = stringPatternPickerCell
            case stringerStyleCell:
                correspondingPickerCell = stringerStylePickerCell
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
            stringDiameterLabel.text = "Main Thickness"
            stringTypeLabel.text = "Main Type"
        } else {
            stringDiameterLabel.text = "Thickness"
            stringTypeLabel.text = "Type"
            if expandedPickerCell == crossStringDiameterPickerCell ||
                expandedPickerCell == crossStringTypePickerCell {
                expandedPickerCell = nil
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func instructionsPressed() {
        // Present alert with instructions.
        let message = """

                     ∙ Remove the dampener!

                     ∙ Tap gently the string once or more times with a stiff object - fingernails, another racquet, finger knuckles etc, while keeping the resonating string as near as possible and in front of the microphone (mounted usually at the bottom of the phone)!

                     ∙ The measurement shows the average string tension between the main and cross strings of the racquet.
                    """
        let alert = UIAlertController(title: "Instructions", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func videoPressed() {
        guard let url = URL(string: "https://www.youtube.com/watch?v=LFTkCCRR7ss&fbclid=IwAR1TVgW87ZbFw0hva-ekLWtdhGU4Zd2RgT1SLLSqpb1Pla8NcljwVGKihQo") else { return }
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
        } else if picker == crossStringDiameterPicker {
            // Cross string diameter picker.
            if let stringDiameter = Double(selectedValue) {
                Settings.shared.crossStringDiameter = stringDiameter
            } else {
                assertionFailure("Cannot convert string to Double: \(selectedValue)")
            }
            // Display it.
            crossStringDiameterValueLabel.text = "\(selectedValue) mm"
        } else if picker == crossStringTypePicker {
            // Cross string type picker.
            if let stringType = StringType(rawValue: selectedValue) {
                Settings.shared.crossStringType = stringType
            } else {
                assertionFailure("Cannot convert string to StringType: \(selectedValue)")
            }
            // Display it.
            crossStringTypeValueLabel.text = selectedValue
        } else if picker == tensionUnitsPicker {
            // Tension units picker.
            if let tensionUnit = TensionUnit(rawValue: selectedValue) {
                Settings.shared.tensionUnit = tensionUnit
            } else {
                assertionFailure("Cannot convert string to TensionUnit: \(selectedValue)")
            }
            // Display it.
            tensionUnitsValueLabel.text = selectedValue
        } else if picker == frameAndGrommetsPicker {
            // Frame and Grommets picker.
            if let frameAndGrommets = FrameAndGrommets(rawValue: selectedValue) {
                Settings.shared.frameAndGrommets = frameAndGrommets
            } else {
                assertionFailure("Cannot convert string to FrameAndGrommets: \(selectedValue)")
            }
            // Display it.
            frameAndGrommetsValueLabel.text = selectedValue
        } else if picker == stringPatternPicker {
            // String pattern picker.
            if let stringPattern = StringPattern(rawValue: selectedValue) {
                Settings.shared.stringPattern = stringPattern
            } else {
                assertionFailure("Cannot convert string to StringPattern: \(selectedValue)")
            }
            // Display it.
            stringPatternValueLabel.text = selectedValue
        } else if picker == stringerStylePicker {
            // Stringer's style picker.
            if let stringerStyle = StringerStyle(rawValue: selectedValue) {
                Settings.shared.stringerStyle = stringerStyle
            } else {
                assertionFailure("Cannot convert string to StringerStyle: \(selectedValue)")
            }
            // Display it.
            stringerStyleValueLabel.text = selectedValue
        }
    }
    
}

