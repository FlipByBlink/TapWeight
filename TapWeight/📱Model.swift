
import SwiftUI
import HealthKit


class 📱Model: ObservableObject {
    
    @Published var 🚩ShowMenu: Bool = false
    
    
    @AppStorage("Unit") var 📏Unit: 📏BodyMassUnit = .kg
    
    @AppStorage("AbleBodyFat") var 🚩AbleBodyFat: Bool = false
    
    @AppStorage("AbleBMI") var 🚩AbleBMI: Bool = false
    
    @AppStorage("Height") var 🧍Height: Int = 165
    
    
    @AppStorage("BodyMass") var 💾BodyMass: Double = 60.0
    
    @AppStorage("BodyFat") var 💾BodyFat: Double = 0.1
    
    @Published var 📝BodyMass: Double = 65.0
    
    @Published var 📝BodyFat: Double = 0.2
    
    var 📝BMI: Double {
        let 🅀uantity = HKQuantity(unit: 📏Unit.ⓐsHKUnit, doubleValue: 📝BodyMass)
        let 🄺iloBodyMass = 🅀uantity.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = 🄺iloBodyMass / pow(Double(🧍Height)/100, 2)
        return Double(Int(round(📝*100)))/100
    }
    
    
    @Published var 🚩ShowResult: Bool = false
    
    @Published var 🚨RegisterError: Bool = false
    
    @Published var 🚩Canceled: Bool = false
    
    @Published var 🚨CancelError: Bool = false
    
    
    @AppStorage("History") var 🕒History: String = ""
    
    
    let 🏥HealthStore = HKHealthStore()
    
    
    var 📦CacheBodyMass: HKQuantitySample?
    var 📦CacheBodyFat: HKQuantitySample?
    var 📦CacheBMI: HKQuantitySample?
    
    
    func 👆Register() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥AuthDenied(.bodyMass) { return }
        
        if 🚩AbleBodyFat {
            if 🏥AuthDenied(.bodyFatPercentage) { return }
        }
        
        if 🚩AbleBMI {
            if 🏥AuthDenied(.bodyMassIndex) { return }
        }
        
        
        do {
            let 🅂ample = HKQuantitySample(type: HKQuantityType(.bodyMass),
                                           quantity: HKQuantity(unit: 📏Unit.ⓐsHKUnit, doubleValue: 📝BodyMass),
                                           start: .now, end: .now)
            
            🏥HealthStore.save(🅂ample) { 🙆, 🙅 in
                DispatchQueue.main.async { [self] in
                    🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyMass, "
                    
                    if 🙆 {
                        💾BodyMass = 📝BodyMass
                        🕒History += 📝BodyMass.description + ", " + 📏Unit.rawValue + "\n"
                        📦CacheBodyMass = 🅂ample
                    } else {
                        🚨RegisterError = true
                        🕒History += ".save Error?! " + 🙅.debugDescription + "\n"
                    }
                }
            }
        }
        
        
        if 🚩AbleBodyFat {
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
                        🚨RegisterError = true
                        🕒History += ".save Error?! " + 🙅.debugDescription + "\n"
                    }
                }
            }
        }
        
        
        if 🚩AbleBMI {
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
                        🚨RegisterError = true
                        🕒History += ".save Error?! " + 🙅.debugDescription + "\n"
                    }
                }
            }
        }
        
        🚩ShowResult = true
    }
    
    
    func 🏥AuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚨RegisterError = true
            🚩ShowResult = true
            🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", "
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
                    self.🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyMass, "
                    
                    if 🙆 {
                        self.🕒History += "Cancel: Success\n"
                        self.📦CacheBodyMass = nil
                    } else {
                        self.🕒History += "Cancel: Error?! " + 🙅.debugDescription + "\n"
                        self.🚨CancelError = true
                    }
                }
            }
        }
        
        if 🚩AbleBodyFat {
            if let 📦 = 📦CacheBodyFat {
                🏥HealthStore.delete(📦) { 🙆, 🙅 in
                    DispatchQueue.main.async {
                        self.🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyFat, "
                        
                        if 🙆 {
                            self.🕒History += "Cancel: Success\n"
                            self.📦CacheBodyFat = nil
                        } else {
                            self.🕒History += "Cancel: Error?! " + 🙅.debugDescription + "\n"
                            self.🚨CancelError = true
                        }
                    }
                }
            }
        }
        
        if 🚩AbleBMI {
            if let 📦 = 📦CacheBMI {
                🏥HealthStore.delete(📦) { 🙆, 🙅 in
                    DispatchQueue.main.async {
                        self.🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BMI, "
                        
                        if 🙆 {
                            self.🕒History += "Cancel: Success\n"
                            self.📦CacheBMI = nil
                        } else {
                            self.🕒History += "Cancel: Error?! " + 🙅.debugDescription + "\n"
                            self.🚨CancelError = true
                        }
                    }
                }
            }
        }
        
        UINotificationFeedbackGenerator().notificationOccurred(.error)
        
        🚩Canceled = true
    }
    
    
    func 🅁eset() {
        🚩ShowResult = false
        🚨RegisterError = false
        🚩Canceled = false
        🚨CancelError = false
    }
}
