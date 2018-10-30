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

    override func viewDidLoad() {
        super.viewDidLoad()

        circleView.layer.cornerRadius = circleView.bounds.width / 2
        
        SoundAnalyzer.shared.delegate = self
        SoundAnalyzer.shared.start { started in
            print("Stared - \(started)")
        }
    }

}

extension MeasureViewController: SoundAnalyzerDelegate {
    
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample) {
        DispatchQueue.main.async { [weak self] in
            if sample.amplitude > 0.08 && sample.frequency > 400 && sample.frequency < 700 {
                self?.tensionNumberLabel.text = String(format: "%0.2f", sample.tensionNumber)
                // Debug info.
                self?.frequencyLabel.text = String(format: "%0.f", sample.frequency)
                self?.amplitudeLabel.text = String(format: "%0.2f", sample.amplitude)
            }
            // Debug info
            self?.currentFrequencyLabel.text = String(format: "Freq - %0.f", sample.frequency)
            self?.currentAmplitudeLabel.text = String(format: "Amp - %0.2f", sample.amplitude)
        }
    }
    
}
