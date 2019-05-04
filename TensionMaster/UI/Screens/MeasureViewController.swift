//
//  MeasureViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/29/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit
import AudioKitUI

class MeasureViewController: UIViewController {
    
    @IBOutlet private var circleView: UIGradientView!
    @IBOutlet private var measureModeLabel: UILabel!
    @IBOutlet private var measureAdjustmentLabel: UILabel!
    @IBOutlet private var tensionNumberLabel: UILabel!
    @IBOutlet private var tensionUnitLabel: UILabel!
    
    @IBOutlet private var headSizeContainer: UIGradientView!
    @IBOutlet private var headSizeLabel: UILabel!
    @IBOutlet private var headSizeValueLabel: UILabel!
    @IBOutlet private var stringerStyleContainer: UIGradientView!
    @IBOutlet private var stringerStyleLabel: UILabel!
    @IBOutlet private var stringerStyleValueLabel: UILabel!
    @IBOutlet private var stringPatternContainer: UIGradientView!
    @IBOutlet private var stringPatternLabel: UILabel!
    @IBOutlet private var stringPatternValueLabel: UILabel!
    @IBOutlet private var openingSizeContainer: UIGradientView!
    @IBOutlet private var openingSizeLabel: UILabel!
    @IBOutlet private var openingSizeValueLabel: UILabel!
    @IBOutlet private var stringDiameterContainer: UIGradientView!
    @IBOutlet private var stringDiameterLabel: UILabel!
    @IBOutlet private var stringDiameterValueLabel: UILabel!
    @IBOutlet private var stringTypeContainer: UIGradientView!
    @IBOutlet private var stringTypeLabel: UILabel!
    @IBOutlet private var stringTypeValueLabel: UILabel!
    @IBOutlet private var crossStringDiameterContainer: UIGradientView!
    @IBOutlet private var crossStringDiameterLabel: UILabel!
    @IBOutlet private var crossStringDiameterValueLabel: UILabel!
    @IBOutlet private var crossStringTypeContainer: UIGradientView!
    @IBOutlet private var crossStringTypeLabel: UILabel!
    @IBOutlet private var crossStringTypeValueLabel: UILabel!
    
    @IBOutlet private var extendedInfoContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var crossContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private var plotView: EZAudioPlot!
    private var plot: AKNodeOutputPlot?
    
    private var lastUpdateSample: SoundAnalyzerSample?
    private var clearWorkItem: DispatchWorkItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlot()
        brand()
        
        SoundAnalyzer.shared.start { started in
            print("Stared - \(started)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Update with the last sample in case the settings are changed.
        if let sample = lastUpdateSample {
            update(sample: sample)
        }
        updateAdditionalInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SoundAnalyzer.shared.delegate = self
        plot?.resume()
        checkFirstRun()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if SoundAnalyzer.shared.delegate === self {
            SoundAnalyzer.shared.delegate = nil
        }
        plot?.pause()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private Methods
    private func brand() {
        if let gradientLayer = view.layer as? CAGradientLayer {
            gradientLayer.colors = [UIColor.backgroundDark.cgColor, UIColor.backgroundLight.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
        // Circle view.
        if let gradientLayer = circleView.layer as? CAGradientLayer {
            gradientLayer.colors = [UIColor.circleStart.cgColor, UIColor.circleEnd.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.cornerRadius = circleView.bounds.width / 2
        }
        // Labels.
        headSizeLabel.textColor = UIColor.accent
        stringerStyleLabel.textColor = UIColor.accent
        stringPatternLabel.textColor = UIColor.accent
        openingSizeLabel.textColor = UIColor.accent
        stringDiameterLabel.textColor = UIColor.accent
        stringTypeLabel.textColor = UIColor.accent
        crossStringDiameterLabel.textColor = UIColor.accent
        crossStringTypeLabel.textColor = UIColor.accent
        // Containers.
        let modifyContainerLayer: (CALayer) -> Void = { layer in
            guard let gradientLayer = layer as? CAGradientLayer else { return }
            gradientLayer.colors = [UIColor.backgroundLight.cgColor, UIColor.backgroundDark.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            gradientLayer.cornerRadius = 16
            gradientLayer.shadowColor = UIColor.black.cgColor
            gradientLayer.shadowOffset = CGSize(width: -3, height: 3)
            gradientLayer.shadowOpacity = 0.3
        }
        modifyContainerLayer(headSizeContainer.layer)
        modifyContainerLayer(stringerStyleContainer.layer)
        modifyContainerLayer(stringPatternContainer.layer)
        modifyContainerLayer(openingSizeContainer.layer)
        modifyContainerLayer(stringDiameterContainer.layer)
        modifyContainerLayer(stringTypeContainer.layer)
        modifyContainerLayer(crossStringDiameterContainer.layer)
        modifyContainerLayer(crossStringTypeContainer.layer)
    }
    
    private func setupPlot() {
        let frame = CGRect(x: 0, y: -20, width: plotView.bounds.width, height: 60)
        let plot = AKNodeOutputPlot(SoundAnalyzer.shared.mic, frame: frame)
        plot.autoresizingMask = .flexibleWidth
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.gain = 1.5 // This number is multiplied by amplitude.
        plot.color = UIColor.soundIndicator
        plot.backgroundColor = UIColor.clear
        plotView.addSubview(plot)
        self.plot = plot
    }
    
    private func update(sample: SoundAnalyzerSample) {
        lastUpdateSample = sample
        
        var tensionValue = sample.tensionNumber
        let settings = Settings.shared
        tensionValue += (settings.measureMode == .calibrated ? settings.tensionAdjustment : 0)
        tensionNumberLabel.text = String(format: "%0.1f", tensionValue)
    }
    
    private func update(adjustment: Double) {
        if adjustment > 0.0 {
            measureAdjustmentLabel.text = "(+\(String(format: "%0.1f", adjustment))\(Settings.shared.tensionUnit.rawValue))"
        } else {
            measureAdjustmentLabel.text = "(\(String(format: "%0.1f", adjustment))\(Settings.shared.tensionUnit.rawValue))"
        }
    }
    
    private func updateAdditionalInfo() {
        let settings = Settings.shared
        if settings.measureMode == .calibrated && settings.tensionAdjustment != 0.0 {
            measureModeLabel.isHidden = false
            measureModeLabel.text = "Calibrated"
            measureAdjustmentLabel.isHidden = false
            update(adjustment: settings.tensionAdjustment)
        } else {
            measureModeLabel.isHidden = true
            measureAdjustmentLabel.isHidden = true
        }
        tensionUnitLabel.text = settings.tensionUnit.rawValue
        stringerStyleValueLabel.text = settings.stringerStyle.rawValue
        stringPatternValueLabel.text = settings.stringPattern.rawValue
        openingSizeValueLabel.text = settings.openingSize.rawValue
        headSizeValueLabel.text = "\(Int(settings.headSize)) \(settings.headSizeUnit.rawValue)"
        stringDiameterValueLabel.text = "\(settings.formattedStringDiameter) mm"
        stringTypeValueLabel.text = settings.stringType.rawValue
        if settings.hybridStringing {
            extendedInfoContainerHeightConstraint.isActive = true
            crossContainerHeightConstraint.isActive = true
            crossStringDiameterContainer.isHidden = false
            crossStringTypeContainer.isHidden = false
            stringDiameterLabel.text = "Main Thickness"
            stringTypeLabel.text = "Main Type"
            crossStringDiameterLabel.text = "Cross Thickness"
            crossStringTypeLabel.text = "Cross Type"
            crossStringDiameterValueLabel.text = "\(settings.formattedCrossStringDiameter) mm"
            crossStringTypeValueLabel.text = settings.crossStringType.rawValue
        } else {
            extendedInfoContainerHeightConstraint.isActive = false
            crossContainerHeightConstraint.isActive = false
            crossStringDiameterContainer.isHidden = true
            crossStringTypeContainer.isHidden = true
            stringDiameterLabel.text = "Thickness"
            stringTypeLabel.text = "Type"
        }
    }
    
    private func checkFirstRun() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "firstRun") == false {
            // Show an information alert.
            let message = """

                     ∙ Remove the dampener!

                     ∙ Tap gently the string once or more times with a stiff object - fingernails, another racquet, finger knuckles etc, while keeping the resonating string as near as possible and in front of the microphone (mounted usually at the bottom of the phone)!

                     ∙ The measurement shows the average string tension between the main and cross strings of the racquet.
                    """
            let alert = UIAlertController(title: "Instructions", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            // Save the first run is passed.
            defaults.set(true, forKey: "firstRun")
            defaults.synchronize()
        }
    }

}

extension MeasureViewController: SoundAnalyzerDelegate {
    
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample) {
        if sample.isValid {
            clearWorkItem?.cancel()
            clearWorkItem = DispatchWorkItem { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.lastUpdateSample = nil
                strongSelf.tensionNumberLabel.text = "0"
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: clearWorkItem!)
            DispatchQueue.main.async { [weak self] in
                self?.update(sample: sample)
            }
        }
    }
    
}
