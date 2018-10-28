//
//  SoundAnalyzer.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/28/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import Foundation
import AudioKit

struct SoundAnalyzerSample {
    let amplitude: Double
    let frequency: Double
}

protocol SoundAnalyzerDelegate: class {
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample)
}

class SoundAnalyzer {
    
    static let shared = SoundAnalyzer()
    var delegate: SoundAnalyzerDelegate?
    var isAnalyzing = false
    private var updateTimer: Timer?
    
    // AudioKit releated.
    lazy var mic = AKMicrophone()
    lazy var tracker = AKFrequencyTracker(mic)
    lazy var booster = AKBooster(tracker, gain: 0)
    
    
    func start(completion: @escaping (Bool) -> Void) {
        if isAnalyzing {
            completion(true)    // Already started.
        }
        let startAnalyzingBlock: () -> Void = {
            // Start audio kit processing.
            AKSettings.audioInputEnabled = true
            AudioKit.output = self.booster
            do {
                try AudioKit.start()
                print("AudioKit started.")
            } catch {
                print("AudioKit did not start!")
                completion(false)
                return
            }
            // Trigger update functionality.
            self.updateTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                let sample = SoundAnalyzerSample(amplitude: self.tracker.amplitude,
                                                 frequency: self.tracker.frequency)
                
//                print("amplitude: \(String(format: "%0.3f", sample.amplitude))                frequency: \(String(format: "%0.1f", sample.frequency))")
                if sample.amplitude > 0.08 && sample.frequency > 400 && sample.frequency < 700 {
                    self.delegate?.soundAnalyzerSample(sample)
                }
            }
            
            // Notify.
            self.isAnalyzing = true
            completion(true)
        }
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            startAnalyzingBlock()   // Granted.
        case .denied:
            completion(false)   // Denied.
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    startAnalyzingBlock()   // Granted.
                } else {
                    completion(false)   // Denied.
                }
            }
        }
    }
    
    func stop() {
        if isAnalyzing == false {
            return
        }
        do {
            try AudioKit.stop()
            print("AudioKit stopped.")
        } catch {
            print("Cannot stop the audio kit...")   // Check how to handle it better...
        }
        self.updateTimer?.invalidate()
        self.updateTimer = nil
        self.isAnalyzing = false
    }
    
}
