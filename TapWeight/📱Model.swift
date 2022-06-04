
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
    
    var 🅀uantityBodyMass: HKQuantity {
        HKQuantity(unit: 💾BodyMassUnit.ⓐsHKUnit, doubleValue: 📝BodyMass)
    }
    
    var 🅀uantityBodyFat: HKQuantity {
        HKQuantity(unit: .percent(), doubleValue: 📝BodyFat)
    }
    
    var 🅀uantityBMI: HKQuantity {
        HKQuantity(unit: .count(), doubleValue: 📝BMI)
    }
    
    var 🅂ampleBodyMass: HKQuantitySample {
        HKQuantitySample(type: HKQuantityType(.bodyMass),
                         quantity: 🅀uantityBodyMass,
                         start: .now,
                         end: .now)
    }
    
    var 🅂ampleBodyFat: HKQuantitySample {
        HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                         quantity: 🅀uantityBodyFat,
                         start: .now,
                         end: .now)
    }
    
    var 🅂ampleBMI: HKQuantitySample {
        HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                         quantity: 🅀uantityBMI,
                         start: .now,
                         end: .now)
    }
    
    @Published var 📝BodyMass: Double = 65.0
    
    @Published var 📝BodyFat: Double = 0.2
    
    var 📝BMI: Double {
        let 🄺iloBodyMass = 🅀uantityBodyMass.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = 🄺iloBodyMass / pow(Double(💾Height)/100, 2)
        return Double(Int(round(📝*100)))/100
    }
    
    
    func 👆Register() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥AuthDenied(.bodyMass) { return }
        
        if 🚩BodyFat && 🏥AuthDenied(.bodyFatPercentage) { return }
        
        if 🚩BMI && 🏥AuthDenied(.bodyMassIndex) { return }
        
        🏥HealthStore.save(🅂ampleBodyMass) { 🙆, 🙅 in
            DispatchQueue.main.async { [self] in
                🄷istory += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyMass, "

                if 🙆 {
                    🚩Success = true
                    🄷istory += 📝BodyMass.description + ", " + 💾BodyMassUnit.rawValue + "\n"
                    💾BodyMass = 📝BodyMass
                } else {
                    🚩Success = false
                    print("🙅:", 🙅.debugDescription)
                    🄷istory += "HealthStore.save error?!\n"
                }
            }
        }

        if 🚩BodyFat {
            🏥HealthStore.save(🅂ampleBodyFat) { 🙆, 🙅 in
                DispatchQueue.main.async { [self] in
                    🄷istory += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyFat, "
                    
                    if 🙆 {
                        🚩Success = true
                        🄷istory += (round(📝BodyFat*1000)/10).description + ", %\n"
                        💾BodyFat = 📝BodyFat
                    } else {
                        🚩Success = false
                        print("🙅:", 🙅.debugDescription)
                        🄷istory += "HealthStore.save error?!\n"
                    }
                }
            }
        }

        if 🚩BMI {
            🏥HealthStore.save(🅂ampleBMI) { 🙆, 🙅 in
                DispatchQueue.main.async { [self] in
                    🄷istory += Date.now.formatted(date: .numeric, time: .shortened) + ", BMI, "
                    
                    if 🙆 {
                        🚩Success = true
                        🄷istory += 📝BMI.description + "\n"
                    } else {
                        🚩Success = false
                        print("🙅:", 🙅.debugDescription)
                        🄷istory += "HealthStore.save error?!\n"
                    }
                }
            }
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
    
    func 🏥RequestAuth(_ ⓣype: HKQuantityTypeIdentifier) {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .notDetermined {
            let 🅃ype: Set<HKSampleType> = [HKQuantityType(ⓣype)]
            🏥HealthStore.requestAuthorization(toShare: 🅃ype, read: nil) { 🙆, 🙅 in
                if 🙆 {
                    print("🏥RequestAuth/" + ⓣype.rawValue + ": Done")
                } else {
                    print("🏥RequestAuth/" + ⓣype.rawValue + ": ERROR")
                    print("🙅:", 🙅.debugDescription)
                }
            }
        }
    }
    
    
    func 🗑Cancel() {
//        guard let 📃 = 📃Sample else { return }
//        
//        🏥HealthStore.delete(📃) { 🙆, 🙅 in
//            if 🙆 {
//                print(".delete: Success")
//                
//                DispatchQueue.main.async {
//                    self.🚩Canceled = true
//                    self.🄷istory += "Cancellation: success\n"
//                }
//                
//                UINotificationFeedbackGenerator().notificationOccurred(.error)
//            } else {
//                print("🙅:", 🙅.debugDescription)
//                
//                DispatchQueue.main.async {
//                    self.🄷istory += "Cancellation: error\n"
//                }
//            }
//        }
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
