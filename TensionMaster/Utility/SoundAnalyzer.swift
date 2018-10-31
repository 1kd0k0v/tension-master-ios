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
    var tensionNumber: Double {
        let settings = Settings.shared
        let d = settings.stringDiameter
        var s = settings.headSize   // It should be in inches!
        if settings.headSizeUnit == .cm {
            s = s / 6.4516
        }
        
        let co = 4.6e-7 * d * d * s
        return co * frequency * frequency
    }
}

protocol SoundAnalyzerDelegate: class {
    func soundAnalyzerSample(_ sample: SoundAnalyzerSample)
}

class SoundAnalyzer {
    
    static let shared = SoundAnalyzer()
    var delegate: SoundAnalyzerDelegate?
    var isAnalyzing = false
    private var timerQueue = DispatchQueue(label: "Timer", qos: .background, attributes: .concurrent)
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
            // Trigger update functionality in dedicated timer queue.
            // Interval = 0.005 ==> 200 ticks (updates) per second.
            self.timerQueue.async {
                let currentRunLoop = RunLoop.current
                self.updateTimer = Timer(timeInterval: 0.005, repeats: true) { _ in
                    self.delegate?.soundAnalyzerSample(SoundAnalyzerSample(amplitude: self.tracker.amplitude,
                                                                           frequency: self.tracker.frequency))
                }
                currentRunLoop.add(self.updateTimer!, forMode: .common)
                currentRunLoop.run()
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
        timerQueue.sync {
            self.updateTimer?.invalidate()
            self.updateTimer = nil
        }
        self.isAnalyzing = false
    }
    
}
