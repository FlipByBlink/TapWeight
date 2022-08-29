
import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    
    @Published var 🚩ShowMenu: Bool = false
    
    @AppStorage("Unit") var 📏Unit: 📏BodyMassUnit = .kg
    @AppStorage("Amount50g") var 🚩Amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩AbleBMI: Bool = false
    @AppStorage("Height") var 🧍Height: Int = 165
    @AppStorage("AbleBodyFat") var 🚩AbleBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩AbleDatePicker: Bool = false
    
    @AppStorage("BodyMass") var 💾BodyMass: Double = 60.0
    @AppStorage("BodyFat") var 💾BodyFat: Double = 0.1
    
    @Published var 📝BodyMass: Double = 65.0
    var 📝BMI: Double {
        let ⓠuantity = HKQuantity(unit: 📏Unit.asHKUnit, doubleValue: 📝BodyMass)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = ⓚiloMassValue / pow(Double(🧍Height)/100, 2)
        return Double(Int(round(📝*10)))/10
    }
    @Published var 📝BodyFat: Double = 0.2
    
    @Published var 📅PickerValue = Date.now
    
    @Published var 🚩ShowResult: Bool = false
    @Published var 🚨RegisterError: Bool = false
    @Published var 🚩Canceled: Bool = false
    @Published var 🚨CancelError: Bool = false
    
    @AppStorage("History") var 🕘History: String = "" //TODO: Delete
    
    let 🏥HealthStore = HKHealthStore()
    var 📦Sample: [HKQuantitySample] = []
    
    var 💽LocalHistory = 💽LocalHistoryModel()
    
    
    @MainActor
    func 👆Register() async {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        
        if 🏥CheckAuthDenied(.bodyMass) { return }
        
        if 🚩AbleBMI {
            if 🏥CheckAuthDenied(.bodyMassIndex) { return }
        }
        
        if 🚩AbleBodyFat {
            if 🏥CheckAuthDenied(.bodyFatPercentage) { return }
        }
        
        let 📅Date: Date = 🚩AbleDatePicker ? 📅PickerValue : .now
        
        📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMass),
                                         quantity: HKQuantity(unit: 📏Unit.asHKUnit, doubleValue: 📝BodyMass),
                                         start: 📅Date, end: 📅Date))
        
        if 🚩AbleBMI {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                             quantity: HKQuantity(unit: .count(), doubleValue: 📝BMI),
                                             start: 📅Date, end: 📅Date))
        }
        
        if 🚩AbleBodyFat {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                             quantity: HKQuantity(unit: .percent(), doubleValue: 📝BodyFat),
                                             start: 📅Date, end: 📅Date))
        }
        
        
        do {
            try await 🏥HealthStore.save(📦Sample)
            
            💾BodyMass = 📝BodyMass
            if 🚩AbleBodyFat { 💾BodyFat = 📝BodyFat }
            
            var ⓔntry = 💽Entry(date: 📅Date)
            ⓔntry.addSample("Body Mass", 📝BodyMass.description + " " + 📏Unit.rawValue)
            if 🚩AbleBMI { ⓔntry.addSample("Body Mass Index", 📝BMI.description) }
            if 🚩AbleBodyFat { ⓔntry.addSample("Body Fat Percentage", (round(📝BodyFat*1000)/10).description + " %") }
            💽LocalHistory.addLog(ⓔntry)
            
            🚩ShowResult = true
            UserDefaults.standard.set(📅Date, forKey: "LastDate")
            
        } catch {
            DispatchQueue.main.async {
                self.💽LocalHistory.addLog("Error: " + error.localizedDescription)
                self.🚨RegisterError = true
                self.🚩ShowResult = true
            }
        }
    }
    
    
    func 🏥CheckAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚨RegisterError = true
            🚩ShowResult = true
            self.💽LocalHistory.addLog("AuthorizationError: " + #function + "\n" + ⓣype.rawValue)
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
                    self.💽LocalHistory.addLog("RequestAuthError: " + error.localizedDescription)
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
            
            💽LocalHistory.modifyCancellation()
            
            UserDefaults.standard.removeObject(forKey: "LastDate")
            
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } catch {
            DispatchQueue.main.async {
                self.💽LocalHistory.addLog("CancelError: " + error.localizedDescription)
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
