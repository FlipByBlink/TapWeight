
import SwiftUI
import HealthKit


class 📱Model: ObservableObject {
    
    @AppStorage("Unit") var 💾BodyMassUnit: 📏BodyMassUnit = .kg
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Double = 60.0
    
    @AppStorage("BodyFat") var 💾BodyFat: Double = 0.1
    
    @AppStorage("Height") var 💾Height: Int = 165
    
    
    @AppStorage("AbleBodyFat") var 🚩BodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩BMI: Bool = false
    
    
    @AppStorage("History") var 🕒History: String = ""
    
    
    @Published var 🚩Registered: Bool = false
    
    @Published var 🚩RegisterError: Bool = false
    
    @Published var 🚩Canceled: Bool = false
    
    @Published var 🚩CancelError: Bool = false
    
    
    let 🏥HealthStore = HKHealthStore()
    
    
    @Published var 📝BodyMass: Double = 65.0
    
    @Published var 📝BodyFat: Double = 0.2
    
    var 📝BMI: Double {
        let 🅀uantity = HKQuantity(unit: 💾BodyMassUnit.ⓐsHKUnit, doubleValue: 📝BodyMass)
        let 🄺iloBodyMass = 🅀uantity.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = 🄺iloBodyMass / pow(Double(💾Height)/100, 2)
        return Double(Int(round(📝*100)))/100
    }
    
    
    var 📦CacheBodyMass: HKQuantitySample?
    var 📦CacheBodyFat: HKQuantitySample?
    var 📦CacheBMI: HKQuantitySample?
    
    
    func 👆Register() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥AuthDenied(.bodyMass) { return }
        
        if 🚩BodyFat {
            if 🏥AuthDenied(.bodyFatPercentage) { return }
        }
        
        if 🚩BMI {
            if 🏥AuthDenied(.bodyMassIndex) { return }
        }
        
        
        do {
            let 🅂ample = HKQuantitySample(type: HKQuantityType(.bodyMass),
                                           quantity: HKQuantity(unit: 💾BodyMassUnit.ⓐsHKUnit, doubleValue: 📝BodyMass),
                                           start: .now, end: .now)
            
            🏥HealthStore.save(🅂ample) { 🙆, 🙅 in
                DispatchQueue.main.async { [self] in
                    🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyMass, "
                    
                    if 🙆 {
                        💾BodyMass = 📝BodyMass
                        🕒History += 📝BodyMass.description + ", " + 💾BodyMassUnit.rawValue + "\n"
                        📦CacheBodyMass = 🅂ample
                    } else {
                        🚩RegisterError = true
                        🕒History += ".save Error?! " + 🙅.debugDescription + "\n"
                    }
                }
            }
        }
        
        
        if 🚩BodyFat {
            let 🅂ample = HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                           quantity: HKQuantity(unit: .percent(), doubleValue: 📝BodyFat),
                                           start: .now, end: .now)
            
            🏥HealthStore.save(🅂ample) { 🙆, 🙅 in
                DispatchQueue.main.async { [self] in
                    🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyFat, "
                    
                    if 🙆 {
                        💾BodyFat = 📝BodyFat
                        🕒History += (round(📝BodyFat*1000)/10).description + ", %\n"
                        📦CacheBodyFat = 🅂ample
                    } else {
                        🚩RegisterError = true
                        🕒History += ".save Error?! " + 🙅.debugDescription + "\n"
                    }
                }
            }
        }
        
        
        if 🚩BMI {
            let 🅂ample = HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                           quantity: HKQuantity(unit: .count(), doubleValue: 📝BMI),
                                           start: .now, end: .now)
            
            🏥HealthStore.save(🅂ample) { 🙆, 🙅 in
                DispatchQueue.main.async { [self] in
                    🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BMI, "
                    
                    if 🙆 {
                        🕒History += 📝BMI.description + "\n"
                        📦CacheBMI = 🅂ample
                    } else {
                        🚩RegisterError = true
                        🕒History += ".save Error?! " + 🙅.debugDescription + "\n"
                    }
                }
            }
        }
        
        🚩Registered = true
    }
    
    
    func 🏥AuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚩RegisterError = true
            🚩Registered = true
            🕒History += "Register/authorization/" + ⓣype.rawValue + ": Error?!\n"
            return true
        }
        
        return false
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
        if let 📦 = 📦CacheBodyMass {
            🏥HealthStore.delete(📦) { 🙆, 🙅 in
                DispatchQueue.main.async {
                    if 🙆 {
                        self.🕒History += "Cancel/BodyMass: Success\n"
                        self.📦CacheBodyMass = nil
                    } else {
                        self.🕒History += "Cancel/BodyMass: Error?! " + 🙅.debugDescription + "\n"
                        self.🚩CancelError = true
                    }
                }
            }
        }
        
        if 🚩BodyFat {
            if let 📦 = 📦CacheBodyFat {
                🏥HealthStore.delete(📦) { 🙆, 🙅 in
                    DispatchQueue.main.async {
                        if 🙆 {
                            self.🕒History += "Cancel/BodyFat: Success\n"
                            self.📦CacheBodyFat = nil
                        } else {
                            self.🕒History += "Cancel/BodyFat: Error?! " + 🙅.debugDescription + "\n"
                            self.🚩CancelError = true
                        }
                    }
                }
            }
        }
        
        if 🚩BMI {
            if let 📦 = 📦CacheBMI {
                🏥HealthStore.delete(📦) { 🙆, 🙅 in
                    DispatchQueue.main.async {
                        if 🙆 {
                            self.🕒History += "Cancel/BMI: Success\n"
                            self.📦CacheBMI = nil
                        } else {
                            self.🕒History += "Cancel/BMI: Error?! " + 🙅.debugDescription + "\n"
                            self.🚩CancelError = true
                        }
                    }
                }
            }
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        🚩Canceled = true
    }
    
    
    func 👆Dismiss() {
        🚩Registered = false
        🚩RegisterError = false
        🚩Canceled = false
        🚩CancelError = false
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
