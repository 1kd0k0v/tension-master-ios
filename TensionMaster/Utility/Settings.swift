//
//  Settings.swift
//  TensionMaster
//
//  Created by Nikolay Markov on 10/31/18.
//  Copyright © 2018 Nikolay Markov. All rights reserved.
//

import Foundation

enum MeasureMode: String {
    case fabric = "Factory"
    case personal = "Personal"
}

enum StringType: String {
    case polyester = "Polyester, Co-polyester"
    case syntheticGut = "Synthetic Gut"
    case naturalGut = "Natural Gut"
    case natGutAndPoly = "Hybrid - natural gut/polyester"
    case synthGutAndPoly = "Hybrid - synthetic gut/polyester"
    case natGutAndSynthGut = "Hybrid - natural/synthetic gut"
    static var allRepresentations: [String] {
        return [polyester.rawValue,
                syntheticGut.rawValue,
                naturalGut.rawValue,
                natGutAndPoly.rawValue,
                synthGutAndPoly.rawValue,
                natGutAndSynthGut.rawValue]
    }
    var coefficient: Double {
        switch self {
        case .polyester: return 1.35
        case .syntheticGut: return 1.12
        case .naturalGut: return 1.28
        case .natGutAndPoly: return 1.3
        case .synthGutAndPoly: return 1.24
        case .natGutAndSynthGut: return 1.21
        }
    }
}

enum SizeUnit: String {
    case inch = "in²"
    case cm = "cm²"
    static var allRepresentations: [String] {
        return [inch.rawValue, cm.rawValue]
    }
}

enum TensionUnit: String {
    case lb
    case kg
    static var allRepresentations: [String] {
        return [lb.rawValue, kg.rawValue]
    }
}

private struct SettingsHolder {
    var measureMode: MeasureMode = .fabric
    var headSizeUnit: SizeUnit = .inch
    var headSize: Double = 98   // inches   (70..130) inches - (500..800) cm
    var stringDiameter: Double = 1.27   // mm   (1.00..1.50) mm
    var stringType: StringType = .polyester
    var tensionUnit: TensionUnit = .kg
    var tensionAdjustment: Double = 0.0
}

private struct Keys {
    static let measureMode = "measureModeKey"
    static let headSizeUnit = "headSizeUnitKey"
    static let headSize = "headSizeKey"
    static let stringDiameter = "stringDiameterKey"
    static let stringType = "stringTypeKey"
    static let tensionUnit = "tensionUnitKey"
    static let tensionAdjustment = "tensionAdjustmentKey"
}

class Settings {
    
    lazy private var settingsHolder = SettingsHolder()
    static let shared = Settings()
    
    let headSizeInchRange = 70...130    // inches
    let headSizeCmRange = 500...800     // cm
    let stringDiameterStride = stride(from: 1.0, through: 1.5, by: 0.005)    // mm
    let stringDiameterFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        return formatter
    }()
    
    var measureMode: MeasureMode {
        get {
            return settingsHolder.measureMode
        }
        set {
            settingsHolder.measureMode = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.measureMode)
        }
    }
    var headSizeUnit: SizeUnit {
        get {
            return settingsHolder.headSizeUnit
        }
        set {
            settingsHolder.headSizeUnit = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.headSizeUnit)
        }
    }
    var headSize: Double {
        get {
            return settingsHolder.headSize
        }
        set {
            settingsHolder.headSize = newValue
            UserDefaults.standard.set(newValue, forKey: Keys.headSize)
        }
    }
    var stringDiameter: Double {
        get {
            return settingsHolder.stringDiameter
        }
        set {
            settingsHolder.stringDiameter = newValue
            UserDefaults.standard.set(newValue, forKey: Keys.stringDiameter)
        }
    }
    var formattedStringDiameter: String {
        get {
            return stringDiameterFormatter.string(from: stringDiameter as NSNumber) ?? String(format: "%0.3f", stringDiameter)
        }
    }
    var stringType: StringType {
        get {
            return settingsHolder.stringType
        }
        set {
            settingsHolder.stringType = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.stringType)
        }
    }
    var tensionUnit: TensionUnit {
        get {
            return settingsHolder.tensionUnit
        }
        set {
            settingsHolder.tensionUnit = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.tensionUnit)
        }
    }
    var tensionAdjustment: Double {
        get {
            return settingsHolder.tensionAdjustment
        }
        set {
            settingsHolder.tensionAdjustment = newValue
            UserDefaults.standard.set(newValue, forKey: Keys.tensionAdjustment)
        }
    }
    
    init() {
        loadFromUserDefaults()
    }
    
    private func loadFromUserDefaults() {
        let defaults = UserDefaults.standard
        // Measure mode.
        if let value = defaults.string(forKey: Keys.measureMode), let measureMode = MeasureMode(rawValue: value) {
            settingsHolder.measureMode = measureMode
        }
        // Head size unit.
        if let value = defaults.string(forKey: Keys.headSizeUnit), let sizeUnit = SizeUnit(rawValue: value) {
            settingsHolder.headSizeUnit = sizeUnit
        }
        // Head size.
        if let value = defaults.object(forKey: Keys.headSize) as? Double {
            settingsHolder.headSize = value
        }
        // String diameter.
        if let value = defaults.object(forKey: Keys.stringDiameter) as? Double {
            settingsHolder.stringDiameter = value
        }
        // String type.
        if let value = defaults.string(forKey: Keys.stringType), let stringType = StringType(rawValue: value) {
            settingsHolder.stringType = stringType
        }
        // Tension units.
        if let value = defaults.string(forKey: Keys.tensionUnit), let tensionUnit = TensionUnit(rawValue: value) {
            settingsHolder.tensionUnit = tensionUnit
        }
        // Tension adjustment.
        if let value = defaults.object(forKey: Keys.tensionAdjustment) as? Double {
            settingsHolder.tensionAdjustment = value
        }
    }
    
}
