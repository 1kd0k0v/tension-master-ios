//
//  ViewController.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/28/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ViewController: UIViewController {
    
    @IBOutlet private var frequencyLabel: UILabel!
    @IBOutlet private var amplitudeLabel: UILabel!
    @IBOutlet private var noteNameWithSharpsLabel: UILabel!
    @IBOutlet private var noteNameWithFlatsLabel: UILabel!
    @IBOutlet private var audioInputPlot: EZAudioPlot!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SoundAnalyzer.shared.delegate = self
        SoundAnalyzer.shared.start { started in
            print("Stared - \(started)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            // 80 - 120 inches^2
            // 500 - 750 cm^2
    }
    
}

extension ViewController: SoundAnalyzerDelegate {
    
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample) {
        func specialNumber(frequency: Double) -> Double {
            let d = 1.27
            let s = 98.0

            let co = 4.8e-7 * d * d * s
            return co * frequency * frequency
        }

        DispatchQueue.main.async { [weak self] in
            self?.frequencyLabel.text = String(format: "%0.1f", sample.frequency)
            let number = specialNumber(frequency: sample.frequency)
            let formattedNumber = String(format: "%0.2f", number)
            self?.noteNameWithSharpsLabel.text = "\(formattedNumber)"
            self?.amplitudeLabel.text = String(format: "%0.2f", sample.amplitude)
        }
    }
    
}

