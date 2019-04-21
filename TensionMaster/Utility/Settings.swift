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
    case polyester = "Polyester"
    case copolyester = "Co-polyester"
    case syntheticGut = "Synthetic Gut"
    case naturalGut = "Natural Gut"
    static var allRepresentations: [String] {
        return [polyester.rawValue,
                copolyester.rawValue,
                syntheticGut.rawValue,
                naturalGut.rawValue]
    }
    var coefficient: Double {
        switch self {
        case .polyester: return 1.35
        case .copolyester: return 1.35
        case .syntheticGut: return 1.12
        case .naturalGut: return 1.28
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

enum FrameAndGrommets: String {
    case increasingTension = "increasing the tension"
    case none = "not influenced"
    case decreasingTension = "decreasing the tension"
    static var allRepresentations: [String] {
        return [increasingTension.rawValue,
                none.rawValue,
                decreasingTension.rawValue]
    }
    var coefficient: Double {
        switch self {
        case .increasingTension: return 0.98
        case .none: return 1
        case .decreasingTension: return 1.02
        }
    }
}

enum StringPattern: String {
    case x14x16 = "14x16"
    case x16x16 = "16x16"
    case x16x17 = "16x17"
    case x16x18 = "16x18"
    case x16x19 = "16x19"
    case x18x17 = "18x17"
    case x18x18 = "18x18"
    case x18x19 = "18x19"
    case x18x20 = "18x20"
    static var allRepresentations: [String] {
        return [x14x16.rawValue,
                x16x16.rawValue,
                x16x17.rawValue,
                x16x18.rawValue,
                x16x19.rawValue,
                x18x17.rawValue,
                x18x18.rawValue,
                x18x19.rawValue,
                x18x20.rawValue]
    }
    var coefficient: Double {
        switch self {
        case .x14x16: return 1.012
        case .x16x16: return 1.009
        case .x16x17: return 1.006
        case .x16x18: return 1.003
        case .x16x19: return 1
        case .x18x17: return 1.003
        case .x18x18: return 0.999
        case .x18x19: return 0.995
        case .x18x20: return 0.990
        }
    }
}

enum StringerStyle: String {
    case veryTight = "very tight"
    case tighter = "tighter"
    case normal = "normal"
    case looser = "looser"
    case veryLoose = "very loose"
    static var allRepresentations: [String] {
        return [veryTight.rawValue,
                tighter.rawValue,
                normal.rawValue,
                looser.rawValue,
                veryLoose.rawValue]
    }
    var coefficient: Double {
        switch self {
        case .veryTight: return 0.94
        case .tighter: return 0.97
        case .normal: return 1
        case .looser: return 1.03
        case .veryLoose: return 1.06
        }
    }
}

private struct SettingsHolder {
    var measureMode: MeasureMode = .fabric
    var headSizeUnit: SizeUnit = .inch
    var headSize: Double = 98   // inches   (70..130) inches - (500..800) cm
    var hybridStringing = false
    var stringDiameter: Double = 1.27   // mm   (1.00..1.50) mm
    var stringType: StringType = .polyester
    var crossStringDiameter: Double = 1.27   // mm   (1.00..1.50) mm
    var crossStringType: StringType = .polyester
    var tensionUnit: TensionUnit = .kg
    var tensionAdjustment: Double = 0.0
    var frameAndGrommets: FrameAndGrommets = .none
    var stringPattern: StringPattern = .x16x19
    var stringerStyle: StringerStyle = .normal
}

private struct Keys {
    static let measureMode = "measureModeKey"
    static let headSizeUnit = "headSizeUnitKey"
    static let headSize = "headSizeKey"
    static let hybridStringing = "hybridStringingKey"
    static let stringDiameter = "stringDiameterKey"
    static let stringType = "stringTypeKey"
    static let frameAndGrommets = "frameAndGrommetsKey"
    static let stringPattern = "stringPatternKey"
    static let stringerStyle = "stringerStyleKey"
    static let crossStringDiameter = "crossStringDiameterKey"
    static let crossStringType = "crossStringTypeKey"
    static let tensionUnit = "tensionUnitKey"
    static let tensionAdjustment = "tensionAdjustmentKey"
}

class Settings {
    
    lazy private var settingsHolder = SettingsHolder()
    static let shared = Settings()
    
    let headSizeInchRange = 70...130    // inches
    let headSizeCmRange = 500...800     // cm
    let stringDiameterStride = stride(from: 1.0, through: 1.5, by: 0.01)    // mm
    let stringDiameterFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = "."
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
    var hybridStringing: Bool {
        get {
            return settingsHolder.hybridStringing
        }
        set {
            settingsHolder.hybridStringing = newValue
            UserDefaults.standard.set(newValue, forKey: Keys.hybridStringing)
        }
    }
    // 1st string.
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
    var frameAndGrommets: FrameAndGrommets {
        get {
            return settingsHolder.frameAndGrommets
        }
        set {
            settingsHolder.frameAndGrommets = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.frameAndGrommets)
        }
    }
    var stringPattern: StringPattern {
        get {
            return settingsHolder.stringPattern
        }
        set {
            settingsHolder.stringPattern = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.stringPattern)
        }
    }
    var stringerStyle: StringerStyle {
        get {
            return settingsHolder.stringerStyle
        }
        set {
            settingsHolder.stringerStyle = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.stringerStyle)
        }
    }
    // Hybrid stringing (cross).
    var crossStringDiameter: Double {
        get {
            return settingsHolder.crossStringDiameter
        }
        set {
            settingsHolder.crossStringDiameter = newValue
            UserDefaults.standard.set(newValue, forKey: Keys.crossStringDiameter)
        }
    }
    var formattedCrossStringDiameter: String {
        get {
            return stringDiameterFormatter.string(from: crossStringDiameter as NSNumber) ?? String(format: "%0.3f", crossStringDiameter)
        }
    }
    var crossStringType: StringType {
        get {
            return settingsHolder.crossStringType
        }
        set {
            settingsHolder.crossStringType = newValue
            UserDefaults.standard.set(newValue.rawValue, forKey: Keys.crossStringType)
        }
    }
    // Tension.
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
        // Hybrid stringing.
        if let value = defaults.object(forKey: Keys.hybridStringing) as? Bool {
            settingsHolder.hybridStringing = value
        }
        // String diameter.
        if let value = defaults.object(forKey: Keys.stringDiameter) as? Double {
            settingsHolder.stringDiameter = value
        }
        // String type.
        if let value = defaults.string(forKey: Keys.stringType), let stringType = StringType(rawValue: value) {
            settingsHolder.stringType = stringType
        }
        // Frame and Grommets.
        if let value = defaults.string(forKey: Keys.frameAndGrommets), let frameAndGrommets = FrameAndGrommets(rawValue: value) {
            settingsHolder.frameAndGrommets = frameAndGrommets
        }
        // String pattern.
        if let value = defaults.string(forKey: Keys.stringPattern), let stringPattern = StringPattern(rawValue: value) {
            settingsHolder.stringPattern = stringPattern
        }
        // Stringer's style.
        if let value = defaults.string(forKey: Keys.stringerStyle), let stringerStyle = StringerStyle(rawValue: value) {
            settingsHolder.stringerStyle = stringerStyle
        }
        // Cross String diameter.
        if let value = defaults.object(forKey: Keys.crossStringDiameter) as? Double {
            settingsHolder.crossStringDiameter = value
        }
        // Cross String type.
        if let value = defaults.string(forKey: Keys.crossStringType), let stringType = StringType(rawValue: value) {
            settingsHolder.crossStringType = stringType
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
