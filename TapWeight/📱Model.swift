
import SwiftUI
import HealthKit


class 📱Model: ObservableObject {
    
//    @AppStorage("Unit") var 📏: 📏Enum = .kg
//
//    @AppStorage("BasalTemp") var 🚩BasalTemp: Bool = false
//
//    @AppStorage("2DecimalPlace") var 🚩2DecimalPlace: Bool = false
//
//    @AppStorage("AutoComplete") var 🚩AutoComplete: Bool = false
//
//
//    @Published var 🧩Temp: [Int] = []
//
//
//    @Published var 🛏BasalSwitch: Bool = true
//
//    @Published var 🚩InputDone: Bool = false
//
//    @Published var 🚩Success: Bool = false
//
//    @Published var 🚩Canceled: Bool = false
//
//    @AppStorage("history") var 🄷istory: String = ""
    
    
    @AppStorage("Unit") var 💾Unit: 📏Enum = .kg
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Double = 60.0
    
    @AppStorage("BodyFat") var 💾BodyFat: Double = 0.1
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    
    @AppStorage("historyBodyMass") var 🄷istoryBodyMass: String = ""
    
    @AppStorage("historyBodyFat") var 🄷istoryBodyFat: String = ""
    
    @AppStorage("historyBMI") var 🄷istoryBMI: String = ""
    
    
    @Published var 🚩InputDone: Bool = false

    @Published var 🚩Success: Bool = false

    @Published var 🚩Canceled: Bool = false
    
    
    let 🏥HealthStore = HKHealthStore()
}


enum 📏Enum: String, CaseIterable {
    case kg
    case lbs
    case st
    
    var 🅄nit: HKUnit {
        switch self {
            case .kg: return .gramUnit(with: .kilo)
            case .lbs: return .pound()
            case .st: return .stone()
        }
    }
}
