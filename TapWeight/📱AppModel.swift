
import SwiftUI
import HealthKit

class 📱AppModel: ObservableObject {
    
    @Published var 🚩ShowMenu: Bool = false
    
    @AppStorage("Unit") var 📏MassUnit: 📏BodyMassUnit = .kg
    @AppStorage("Amount50g") var 🚩Amount50g: Bool = false
    @AppStorage("AbleBMI") var 🚩AbleBMI: Bool = false
    @AppStorage("Height") var 🧍HeightValue: Int = 165
    @AppStorage("AbleBodyFat") var 🚩AbleBodyFat: Bool = false
    @AppStorage("AbleDatePicker") var 🚩AbleDatePicker: Bool = false
    
    @Published var 📝MassValue: Double = 65.0
    var 📝BMIValue: Double {
        let ⓠuantity = HKQuantity(unit: 📏MassUnit.hkunit, doubleValue: 📝MassValue)
        let ⓚiloMassValue = ⓠuantity.doubleValue(for: .gramUnit(with: .kilo))
        let 📝 = ⓚiloMassValue / pow(Double(🧍HeightValue)/100, 2)
        return Double(Int(round(📝*10)))/10
    }
    @Published var 📝BodyFatValue: Double = 0.2
    
    @Published var 📅PickerValue = Date.now
    
    @Published var 🚩ShowResult: Bool = false
    @Published var 🚨RegisterError: Bool = false
    @Published var 🚩Canceled: Bool = false
    @Published var 🚨CancelError: Bool = false
    
    @Published var 🕘LocalHistory = 🕘LocalHistoryModel()
    
    let 🏥HealthStore = HKHealthStore()
    
    var 📦Sample: [HKQuantitySample] = []
    
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
                                         quantity: HKQuantity(unit: 📏MassUnit.hkunit, doubleValue: 📝MassValue),
                                         start: 📅Date, end: 📅Date))
        
        if 🚩AbleBMI {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyMassIndex),
                                             quantity: HKQuantity(unit: .count(), doubleValue: 📝BMIValue),
                                             start: 📅Date, end: 📅Date))
        }
        
        if 🚩AbleBodyFat {
            📦Sample.append(HKQuantitySample(type: HKQuantityType(.bodyFatPercentage),
                                             quantity: HKQuantity(unit: .percent(), doubleValue: 📝BodyFatValue),
                                             start: 📅Date, end: 📅Date))
        }
        
        
        do {
            try await 🏥HealthStore.save(📦Sample)
            
            var ⓔntry = 🕘Entry(date: 📅Date, massSample: .init(unit: 📏MassUnit, value: 📝MassValue))
            ⓔntry.bmiValue = 📝BMIValue
            ⓔntry.bodyFatValue = 📝BodyFatValue
            🕘LocalHistory.addLog(ⓔntry)
            
            🚩ShowResult = true
        } catch {
            DispatchQueue.main.async {
                self.🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
                self.🚨RegisterError = true
                self.🚩ShowResult = true
            }
        }
    }
    
    
    func 🏥CheckAuthDenied(_ ⓣype: HKQuantityTypeIdentifier) -> Bool {
        if 🏥HealthStore.authorizationStatus(for: HKQuantityType(ⓣype)) == .sharingDenied {
            🚨RegisterError = true
            🚩ShowResult = true
            self.🕘LocalHistory.addLog("Error: " + #function + ⓣype.rawValue)
            return true
        } else {
            return false
        }
    }
    
    
    func 🏥RequestAuth(_ ⓘdentifier: HKQuantityTypeIdentifier) {
        let 🅃ype: HKSampleType = HKQuantityType(ⓘdentifier)
        if 🏥HealthStore.authorizationStatus(for: 🅃ype) == .notDetermined {
            Task {
                do {
                    try await 🏥HealthStore.requestAuthorization(toShare: [🅃ype], read: [])
                } catch {
                    self.🕘LocalHistory.addLog("Error: " + #function + error.localizedDescription)
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
            🕘LocalHistory.modifyCancellation()
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        } catch {
            DispatchQueue.main.async {
                self.🕘LocalHistory.addLog("Error: " + error.localizedDescription)
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
