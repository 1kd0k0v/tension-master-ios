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
    
    @IBOutlet private var circleView: UIView!
    @IBOutlet private var measureModeLabel: UILabel!
    @IBOutlet private var measureAdjustmentLabel: UILabel!
    @IBOutlet private var tensionNumberLabel: UILabel!
    @IBOutlet private var tensionUnitLabel: UILabel!
    
    @IBOutlet private var headSizeLabel: UILabel!
    @IBOutlet private var stringDiameterLabel: UILabel!
    @IBOutlet private var stringTypeLabel: UILabel!
    
    @IBOutlet private var plotView: EZAudioPlot!
    private var plot: AKNodeOutputPlot?
    
    private var lastUpdateSample: SoundAnalyzerSample?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPlot()
        circleView.layer.cornerRadius = circleView.bounds.width / 2
        
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
    
    // MARK: - Private Methods
    private func setupPlot() {
        let plot = AKNodeOutputPlot(SoundAnalyzer.shared.mic, frame: plotView.bounds)
        plot.autoresizingMask = .flexibleWidth
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.gain = 1.5 // This number is multiplied by amplitude.
        plot.color = UIColor.green
        plotView.addSubview(plot)
        self.plot = plot
    }
    
    private func update(sample: SoundAnalyzerSample) {
        lastUpdateSample = sample
        
        var tensionValue = sample.tensionNumber
        let settings = Settings.shared
        tensionValue += (settings.measureMode == .personal ? settings.tensionAdjustment : 0)
        let tensionString = String(format: "%0.2f", tensionValue)
        tensionNumberLabel.attributedText = NSAttributedString.tensionString(tensionString, font: tensionNumberLabel.font)
    }
    
    private func update(adjustment: Double) {
        if adjustment >= 0.0 {
            measureAdjustmentLabel.text = "(+\(String(format: "%0.1f", adjustment))\(Settings.shared.tensionUnit.rawValue))"
        } else {
            measureAdjustmentLabel.text = "(\(String(format: "%0.1f", adjustment))\(Settings.shared.tensionUnit.rawValue))"
        }
    }
    
    private func updateAdditionalInfo() {
        let settings = Settings.shared
        if settings.measureMode == .personal {
            measureAdjustmentLabel.isHidden = false
            update(adjustment: settings.tensionAdjustment)
        } else {
            measureAdjustmentLabel.isHidden = true
        }
        measureModeLabel.text = "\(settings.measureMode.rawValue) Mode"
        tensionUnitLabel.text = settings.tensionUnit.rawValue
        headSizeLabel.text = "\(Int(settings.headSize)) \(settings.headSizeUnit.rawValue)"
        stringDiameterLabel.text = "\(String(format: "%0.2f", settings.stringDiameter)) mm"
        stringTypeLabel.text = settings.stringType.rawValue
    }
    
    private func checkFirstRun() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "firstRun") == false {
            // Show an information alert.
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
            // Save the first run is passed.
            defaults.set(true, forKey: "firstRun")
            defaults.synchronize()
        }
    }

}

extension MeasureViewController: SoundAnalyzerDelegate {
    
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample) {
        if sample.isValid {
            DispatchQueue.main.async { [weak self] in
                self?.update(sample: sample)
            }
        }
    }
    
}
