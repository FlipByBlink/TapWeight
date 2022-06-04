
import SwiftUI
import HealthKit

class 📱Model: ObservableObject {
    
    @AppStorage("Unit") var 💾BodyMassUnit: 📏BodyMassUnit = .kg
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Double = 60.0
    
    @AppStorage("BodyFat") var 💾BodyFat: Double = 0.1
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    
    @AppStorage("history") var 🄷istory: String = ""
    
    
    @Published var 🚩InputDone: Bool = false

    @Published var 🚩Success: Bool = false

    @Published var 🚩Canceled: Bool = false
    
    
    let 🏥HealthStore = HKHealthStore()
    
    @Published var 📝BodyMass: Double = 65.0
    
    @Published var 📝BodyFat: Double = 0.2
    
    var 📝BMI: Double {
        let 🅀uantity = HKQuantity(unit: 💾BodyMassUnit.ⓐsHKUnit, doubleValue: 📝BodyMass)
        let 🄺iloBodyMass = 🅀uantity.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = 🄺iloBodyMass / pow(Double(💾Height)/100, 2)
        return Double(Int(round(📝*100)))/100
    }
    
    
    var 🔖CacheSample: [HKQuantitySample] = []
    
    func 👆Register() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥AuthDenied(.bodyMass) { return }
        
        if 🚩BodyFat && 🏥AuthDenied(.bodyFatPercentage) { return }
        
        if 🚩BMI && 🏥AuthDenied(.bodyMassIndex) { return }
        
        🏥Save(.bodyMass, 💾BodyMassUnit.ⓐsHKUnit, 📝BodyMass, 📝BodyMass.description)
        💾BodyMass = 📝BodyMass

        if 🚩BodyFat {
            🏥Save(.bodyFatPercentage, .percent(), 📝BodyFat, (round(📝BodyFat*1000)/10).description)
            💾BodyFat = 📝BodyFat
        }

        if 🚩BMI {
            🏥Save(.bodyMassIndex, .count(), 📝BMI, 📝BMI.description)
        }
        
        🚩InputDone = true
    }
    
    func 🏥AuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚩Success = false
            🚩InputDone = true
            return true
        }
        
        return false
    }
    
    func 🏥Save(_ ⓘdentifier: HKQuantityTypeIdentifier, _ ⓤnit: HKUnit, _ ⓥalue: Double, _ ⓣext: String) {
        let 🅂ample = HKQuantitySample(type: HKQuantityType(ⓘdentifier),
                                  quantity: HKQuantity(unit: ⓤnit, doubleValue: ⓥalue),
                                  start: .now,
                                  end: .now)
        
        🏥HealthStore.save(🅂ample) { 🙆, 🙅 in
            DispatchQueue.main.async { [self] in
                🄷istory += Date.now.formatted(date: .numeric, time: .shortened) + ", " + ⓘdentifier.rawValue + ", "
                
                if 🙆 {
                    🚩Success = true
                    🄷istory += ⓣext + ", " + ⓤnit.description + "\n"
                    🔖CacheSample.append(🅂ample)
                } else {
                    🚩Success = false
                    print("🙅:", 🙅.debugDescription)
                    🄷istory += "HealthStore.save error?!\n"
                }
            }
        }
    }
    
    func 🏥RequestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓘdentifier)) == .notDetermined {
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(ⓘdentifier)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("🏥RequestAuth/" + ⓘdentifier.rawValue + ": Done")
                } else {
                    print("🏥RequestAuth/" + ⓘdentifier.rawValue + ": ERROR")
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
    }
    
    
    func 🗑Cancel() {
        🔖CacheSample.forEach { sample in
            🏥HealthStore.delete(sample) { 🙆, 🙅 in
                if 🙆 {
                    print(".delete/" + sample.quantityType.description + ": Success")
                    
                    DispatchQueue.main.async {
                        self.🚩Canceled = true
                        self.🄷istory += "Cancellation/" + sample.quantityType.description + ": success\n"
                    }
                    
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                } else {
                    print(".delete/" + sample.quantityType.description + ": 🙅", 🙅.debugDescription)
                    
                    DispatchQueue.main.async {
                        self.🄷istory += "Cancellation/" + sample.quantityType.description + ": error\n"
                    }
                }
            }
        }
        
        🔖CacheSample.removeAll()
        
        🚩Canceled = true
    }
    
    
    // ======== AD ========
    @Published var 🚩AdBanner = false
    
    var 🄰ppName: 🗯AppList {
        switch ( 🄻aunchCount / 🅃iming ) % 3 {
            case 0: return .FlipByBlink
            case 1: return .FadeInAlarm
            default: return .Plain将棋盤
        }
    }
    
    var 🅃iming: Int = 7
    
    @AppStorage("🄻aunchCount") var 🄻aunchCount: Int = 0
}


enum 📏BodyMassUnit: String, CaseIterable {
    case kg
    case lbs
    case st
    
    var ⓐsHKUnit: HKUnit {
        switch self {
            case .kg: return .gramUnit(with: .kilo)
            case .lbs: return .pound()
            case .st: return .stone()
        }
    }
}
