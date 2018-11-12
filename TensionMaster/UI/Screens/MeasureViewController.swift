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
        
        SoundAnalyzer.shared.delegate = self
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
        
        plot?.resume()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        plot?.pause()
    }
    
    // MARK: - Private Methods
    private func setupPlot() {
        let plot = AKNodeOutputPlot(SoundAnalyzer.shared.mic, frame: plotView.bounds)
        plot.autoresizingMask = .flexibleWidth
        plot.plotType = .buffer
        plot.gain = 1.5 // This number is multiplied by amplitude.
        plot.color = UIColor.green
        plotView.addSubview(plot)
        self.plot = plot
    }
    private func update(sample: SoundAnalyzerSample) {
        lastUpdateSample = sample
        
        tensionNumberLabel.text = String(format: "%0.2f", sample.tensionNumber)
    }
    
    private func updateAdditionalInfo() {
        let settings = Settings.shared
        measureModeLabel.text = "\(settings.measureMode.rawValue) Mode"
        tensionUnitLabel.text = settings.tensionUnit.rawValue
        headSizeLabel.text = "\(Int(settings.headSize)) \(settings.headSizeUnit.rawValue)"
        stringDiameterLabel.text = "\(String(format: "%0.2f", settings.stringDiameter)) mm"
        stringTypeLabel.text = settings.stringType.rawValue
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
