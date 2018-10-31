//
//  MeasureViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/29/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit

class MeasureViewController: UIViewController {
    
    @IBOutlet private var circleView: UIView!
    @IBOutlet private var tensionNumberLabel: UILabel!
    
    @IBOutlet private var frequencyLabel: UILabel!
    @IBOutlet private var currentFrequencyLabel: UILabel!
    @IBOutlet private var amplitudeLabel: UILabel!
    @IBOutlet private var currentAmplitudeLabel: UILabel!
    
    private var lastUpdateSample: SoundAnalyzerSample?

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    // MARK: - Private Methods
    private func update(sample: SoundAnalyzerSample) {
        lastUpdateSample = sample
        
        tensionNumberLabel.text = String(format: "%0.2f", sample.tensionNumber)
        // Debug info.
        frequencyLabel.text = String(format: "%0.f", sample.frequency)
        amplitudeLabel.text = String(format: "%0.2f", sample.amplitude)
    }

}

extension MeasureViewController: SoundAnalyzerDelegate {
    
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample) {
        DispatchQueue.main.async { [weak self] in
            if sample.amplitude > 0.08 && sample.frequency > 400 && sample.frequency < 700 {
                self?.update(sample: sample)
            }
            // Debug info
            self?.currentFrequencyLabel.text = String(format: "Freq - %0.f", sample.frequency)
            self?.currentAmplitudeLabel.text = String(format: "Amp - %0.2f", sample.amplitude)
        }
    }
    
}
