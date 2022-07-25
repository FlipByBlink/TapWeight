
import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    
    @Published var 🚩ShowMenu: Bool = false
    
    @AppStorage("Unit") var 📏Unit: 📏BodyMassUnit = .kg
    @AppStorage("Amount50g") var 🚩Amount50g: Bool = false
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
        return Double(Int(round(📝*10)))/10
    }
    
    @Published var 🚩ShowResult: Bool = false
    @Published var 🚨RegisterError: Bool = false
    @Published var 🚩Canceled: Bool = false
    @Published var 🚨CancelError: Bool = false
    
    @AppStorage("History") var 🕒History: String = ""
    
    let 🏥HealthStore = HKHealthStore()
    var 📦Sample: [HKQuantitySample] = []
    
    
    @MainActor
    func 👆Register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥CheckAuthDenied(.bodyMass) { return }
        
        if 🚩AbleBodyFat {
            if 🏥CheckAuthDenied(.bodyFatPercentage) { return }
        }
        
        if 🚩AbleBMI {
            if 🏥CheckAuthDenied(.bodyMassIndex) { return }
        }
        
        
        📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                         quantity: HKQuantity(unit: 📏Unit.ⓐsHKUnit, doubleValue: 📝BodyMass),
                                         start: .now, end: .now))
        
        if 🚩AbleBodyFat {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                             quantity: HKQuantity(unit: .percent(), doubleValue: 📝BodyFat),
                                             start: .now, end: .now))
        }
        
        if 🚩AbleBMI {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                             quantity: HKQuantity(unit: .count(), doubleValue: 📝BMI),
                                             start: .now, end: .now))
        }
        
        
        do {
            try await 🏥HealthStore.save(📦Sample)
            
            
            💾BodyMass = 📝BodyMass
            🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyMass, "
            🕒History += 📝BodyMass.description + ", " + 📏Unit.rawValue + "\n"
            
            if 🚩AbleBodyFat {
                💾BodyFat = 📝BodyFat
                🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BodyFat, "
                🕒History += (round(📝BodyFat*1000)/10).description + ", %\n"
            }
            
            if 🚩AbleBMI {
                🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", BMI, "
                🕒History += 📝BMI.description + "\n"
            }
            
            
            🚩ShowResult = true
            
        } catch {
            DispatchQueue.main.async {
                print(#function, error)
                self.🚨RegisterError = true
                self.🕒History += ".save Error?! " + error.localizedDescription + "\n"
                self.🚩ShowResult = true
            }
        }
    }
    
    
    func 🏥CheckAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
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
        let 🅃ype: HKSampleType = HKQuantityType(ⓘdentifier)
        if 🏥HealthStore.authorizationStatus(for: 🅃ype) == .notDetermined {
            Task {
                do {
                    try await 🏥HealthStore.requestAuthorization(toShare: [🅃ype], read: [])
                } catch {
                    print(#function, error)
                }
            }
        }
    }
    
    
    @MainActor
    func 🗑Cancel() async {
        do {
            🚩Canceled = true
            
            try await 🏥HealthStore.delete(📦Sample)
            
            📦Sample = []
            
            🕒History += Date.now.formatted(date: .numeric, time: .shortened) + ", "
            🕒History += "Cancel: Success\n"
            
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } catch {
            DispatchQueue.main.async {
                print(#function, error)
                self.🕒History += "Cancel: Error?! " + error.localizedDescription + "\n"
                self.🚨CancelError = true
            }
        }
    }
    
    
    func 🅁eset() {
        🚩ShowResult = false
        🚨RegisterError = false
        🚩Canceled = false
        🚨CancelError = false
        📦Sample = []
    }
}
